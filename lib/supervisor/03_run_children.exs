defmodule Parent do
  def spawn_link(limits) do
    spawn_link(__MODULE__, :init, [limits])
  end

  def init(limits) do
    Process.flag :trap_exit, true

    Enum.each(limits, fn(limit_num) ->
      spawn_link(Child, :init, [limit_num])
    end)

    loop()
  end

  def loop() do
    receive do
      msg -> 
        IO.puts "Parent got message: #{inspect msg}"
        loop()
    end
  end
end


defmodule Child do
  def init(limit) do
    loop(limit)
  end

  def loop(0), do: :ok
  def loop(n) when n > 0 do
    IO.puts "Process #{inspect self()} counter #{n}"
    Process.sleep 500
    loop(n-1)
  end
end


Parent.init([2,3,5])

Process.sleep 2_000
