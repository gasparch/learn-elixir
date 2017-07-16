
Process.flag :trap_exit, true

IO.puts "before"
spawn_link fn() -> 1=2 end
Process.sleep 100
IO.puts "after"

receive do
  msg -> IO.inspect msg, label: "received message"
end
