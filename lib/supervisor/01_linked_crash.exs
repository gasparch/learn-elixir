
IO.puts "before"
spawn_link fn() -> 1 = 2 end
Process.sleep 100
IO.puts "after"
