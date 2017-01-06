# erlang blog: http://www.lshift.net/blog/2006/09/10/how-fast-can-erlang-create-processes/
defmodule IpcTest do

  def oneway() do
    n = 10000000
    pid = spawn(IpcTest, :consumer, [])
    start =  :os.timestamp
    dotimes(n-1, fn () ->
      send(pid, :message)
    end)
    send(pid, {:done, self()})
    receive do
      :ok -> :ok
    end
    stop =  :os.timestamp
    n / time_diff(start, stop)
  end

  def pingpong() do
    n = 10000000
    pid = spawn(IpcTest, :consumer, [])
    #start = :erlang.now
    # start =  :erlang.timestamp
    start =  :os.timestamp
    message = {:ping, self()}
    dotimes(n, fn() ->
      send pid, message
      receive do
        :pong -> :ok
      end
    end)
    # stop = :erlang.now
    # stop =  :erlang.timestamp
    stop =  :os.timestamp
    n / time_diff(start, stop)
  end

  def consumer() do
    receive do
      :message -> consumer()
      {:done, pid} -> send pid, :ok
      {:ping, pid} ->
        send pid, :pong
        consumer()
    end
  end

  def dotimes(0, _), do: :done
  def dotimes(n, f) do
    f.()
    dotimes(n - 1, f)
  end

  def time_diff({a1,a2,a3}, {b1,b2,b3}) do
    (b1-a1) * 1000000 + (b2 - a2) + (b3 - a3) / 1000000
  end
  def time_diff(a, b) do
    b - a
  end
end
