
IO.puts "before"
spawn_link fn() -> :ok end
Process.sleep 100
IO.puts "after"
