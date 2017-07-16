defmodule Parent do
  use Supervisor

  def start_link(limits) do
    Supervisor.start_link(__MODULE__, limits)
  end

  def init(limits) do
    children = Enum.map(limits, fn(limit_num) ->
      worker(Child, [limit_num], [id: limit_num, restart: :permanent])
    end)

    supervise(children, strategy: :one_for_one)
  end
end

defmodule Child do
  def start_link(limit) do
    pid = spawn_link(__MODULE__, :init, [limit])
    {:ok, pid}
  end

  def init(limit) do
    IO.puts "Start child with limit #{limit} pid #{inspect self()}"
    loop(limit)
  end

  def loop(0), do: :ok
  def loop(n) when n > 0 do
    IO.puts "Process #{inspect self()} counter #{n}"
    Process.sleep 500
    loop(n-1)
  end
end


Parent.start_link([2,3,5])

Process.sleep 10_000
