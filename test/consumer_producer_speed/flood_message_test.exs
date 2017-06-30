defmodule Test.ProducerConsumer.Flood do
  use ExUnit.Case


  def producer_loop(report_to_pid, msg_count, consumer_pid) do
    {time, _} = :timer.tc(fn() -> producer_loop_timed(msg_count, consumer_pid) end)

    send report_to_pid, {:producer_time, time}
  end

  def producer_loop_timed(0, consumer_pid) do
    send consumer_pid, :stop_processing
    :ok
  end
  def producer_loop_timed(n, consumer_pid) when n > 0 do
    message = {:message, n}
    send consumer_pid, message
    producer_loop_timed(n-1, consumer_pid)
  end

  def consumer_loop(report_to_pid) do
    {time, _} = :timer.tc(&consumer_loop_timed/0) 
    send report_to_pid, {:consumer_time, time}
  end

  defp consumer_loop_timed() do
    consumer_loop_timed("")
  end
  defp consumer_loop_timed(msg) do
    receive do
      {:message, n} -> 
        msg = msg <> "#{n*n*n*n*n*n*n}"
        msg = if byte_size(msg) > 10_000 do
          ""
        else
          msg
        end
        consumer_loop_timed(msg)
      :stop_processing -> :ok
    end
  end

  defp check_consumer_queue(consumer_pid) do
    check_consumer_queue(consumer_pid, 0)
  end
  defp check_consumer_queue(_consumer_pid, 2) do
    # exit when both processes reported back
    :ok
  end
  defp check_consumer_queue(consumer_pid, report_count) do
    receive do
      {:producer_time, time} -> 
        IO.puts "Producer finished in #{time} usec"
        check_consumer_queue(consumer_pid, report_count+1)
      {:consumer_time, time} -> 
        IO.puts "Consumer finished in #{time} usec"
        check_consumer_queue(consumer_pid, report_count+1)
    after 
      100 ->
        msg_count = Process.info(consumer_pid)[:message_queue_len]
        IO.puts "Consumer message queue #{msg_count}"
        check_consumer_queue(consumer_pid, report_count)
    end
  end

  test "send 500k messages" do
    message_count = 500_000

    Process.flag :trap_exit, true

    report_to_pid = self()

    IO.puts "Working on #{message_count} messages"

    {:ok, consumer} = Task.start_link(fn() -> consumer_loop(report_to_pid) end)

    {:ok, _producer} = Task.start_link(fn() -> producer_loop(report_to_pid, message_count, consumer) end)

    {time, _} = :timer.tc(fn() -> check_consumer_queue(consumer) end)
    IO.puts "Total time is #{time} usec"
  end

end

