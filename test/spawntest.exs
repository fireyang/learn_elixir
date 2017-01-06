# erlang blog: http://www.lshift.net/blog/2006/09/10/how-fast-can-erlang-create-processes/
defmodule SpawnTest do

  def serial_spawn(m) do
    n = 1000000
    nPm = div(n, m)
    start = :erlang.now()
    dotimes(m, fn () ->
      serial_spawn(self(), nPm)
    end)
    dotimes(m, fn () ->
      #IO.puts"receive"
      receive do
        x -> x
      end
    end)
    stop = :erlang.now()
    (nPm * m) / time_diff(start, stop)
  end

  def serial_spawn(who, 0) do
    send(who, :done)
  end
  def serial_spawn(who, count) do
    spawn(fn() ->
      serial_spawn(who, count - 1)
    end)
  end

  def dotimes(0, _), do: :done
  def dotimes(n, f) do
    f.()
    dotimes(n - 1, f)
  end

  def time_diff({a1,a2,a3}, {b1,b2,b3}) do
    (b1-a1) * 1000000 + (b2 - a2) + (b3 - a3) / 1000000
  end


end
