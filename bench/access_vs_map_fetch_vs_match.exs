defmodule AccessVsMapFetchVsMatch do
  use Benchfella

  @iterations 1
  @content_value 123

  defp create_map_n(n) do
    0..(n-1) |> Enum.map( &{:"kw#{&1}", @content_value} ) |> Enum.into(%{})
  end

  defp create_kw_n(n) do
    0..(n-1) |> Enum.map( &{:"kw#{&1}", @content_value} )
  end

  defp create_keys_list(n) do
    0..(n-1) |> Enum.map( &:"kw#{&1}" ) |> Enum.reverse()
  end

  defp access_map(map, []) do
    map
  end
  defp access_map(map, [h|t]) do
    val = map[h]
    access_map(map, t)
  end

  defp map_fetch(map, []) do
    map
  end
  defp map_fetch(map, [h|t]) do
    val = Map.fetch map, h
    map_fetch(map, t)
  end

  defp match(map, []) do
    map
  end
  defp match(map, [h|t]) do
    %{^h => val} = map
    match(map, t)
  end

  defp access_kw(map, []) do
    map
  end
  defp access_kw(map, [h|t]) do
    val = map[h]
    access_kw(map, t)
  end

  defp kw_get(kw, []) do
    kw
  end
  defp kw_get(kw, [h|t]) do
    val = Keyword.get kw, h
    kw_get(kw, t)
  end

  defp kw_get_unroll(kw, []) do
    kw
  end
  defp kw_get_unroll(kw, [h|t]) do
    val = case kw do
      [{h, v}|_] -> v
      [_, {h, v}|_] -> v
      [_, _, {h, v}|_] -> v
      [_, _, _, {h, v}|_] -> v
      _ -> Keyword.get kw, h
    end
    kw_get_unroll(kw, t)
  end

  defp baseline(kw, _) do
    kw
  end

  bench "access_map1",    [keys: create_keys_list(1), val: create_map_n(1)],    do: access_map(val, keys)
  bench "access_map2",    [keys: create_keys_list(2), val: create_map_n(2)],    do: access_map(val, keys)
  bench "access_map3",    [keys: create_keys_list(3), val: create_map_n(3)],    do: access_map(val, keys)
  bench "access_map4",    [keys: create_keys_list(4), val: create_map_n(4)],    do: access_map(val, keys)
  bench "access_map8",    [keys: create_keys_list(8), val: create_map_n(8)],    do: access_map(val, keys)
  bench "access_map16",   [keys: create_keys_list(16), val: create_map_n(16)],   do: access_map(val, keys)
  bench "access_map32",   [keys: create_keys_list(32), val: create_map_n(32)],   do: access_map(val, keys)

  bench "map_fetch1",    [keys: create_keys_list(1), val: create_map_n(1)],    do: map_fetch(val, keys)
  bench "map_fetch2",    [keys: create_keys_list(2), val: create_map_n(2)],    do: map_fetch(val, keys)
  bench "map_fetch3",    [keys: create_keys_list(3), val: create_map_n(3)],    do: map_fetch(val, keys)
  bench "map_fetch4",    [keys: create_keys_list(4), val: create_map_n(4)],    do: map_fetch(val, keys)
  bench "map_fetch8",    [keys: create_keys_list(8), val: create_map_n(8)],    do: map_fetch(val, keys)
  bench "map_fetch16",   [keys: create_keys_list(16), val: create_map_n(16)],   do: map_fetch(val, keys)
  bench "map_fetch32",   [keys: create_keys_list(32), val: create_map_n(32)],   do: map_fetch(val, keys)

  bench "match1",    [keys: create_keys_list(1), val: create_map_n(1)],    do: match(val, keys)
  bench "match2",    [keys: create_keys_list(2), val: create_map_n(2)],    do: match(val, keys)
  bench "match3",    [keys: create_keys_list(3), val: create_map_n(3)],    do: match(val, keys)
  bench "match4",    [keys: create_keys_list(4), val: create_map_n(4)],    do: match(val, keys)
  bench "match8",    [keys: create_keys_list(8), val: create_map_n(8)],    do: match(val, keys)
  bench "match16",   [keys: create_keys_list(16), val: create_map_n(16)],   do: match(val, keys)
  bench "match32",   [keys: create_keys_list(32), val: create_map_n(32)],   do: match(val, keys)

  bench "access_kw1",    [keys: create_keys_list(1), val: create_kw_n(1)],    do: access_kw(val, keys)
  bench "access_kw2",    [keys: create_keys_list(2), val: create_kw_n(2)],    do: access_kw(val, keys)
  bench "access_kw3",    [keys: create_keys_list(3), val: create_kw_n(3)],    do: access_kw(val, keys)
  bench "access_kw4",    [keys: create_keys_list(4), val: create_kw_n(4)],    do: access_kw(val, keys)
  bench "access_kw8",    [keys: create_keys_list(8), val: create_kw_n(8)],    do: access_kw(val, keys)
  bench "access_kw16",   [keys: create_keys_list(16), val: create_kw_n(16)],   do: access_kw(val, keys)
  bench "access_kw32",   [keys: create_keys_list(32), val: create_kw_n(32)],   do: access_kw(val, keys)

  bench "kw_get1",    [keys: create_keys_list(1), val: create_kw_n(1)],    do: kw_get(val, keys)
  bench "kw_get2",    [keys: create_keys_list(2), val: create_kw_n(2)],    do: kw_get(val, keys)
  bench "kw_get3",    [keys: create_keys_list(3), val: create_kw_n(3)],    do: kw_get(val, keys)
  bench "kw_get4",    [keys: create_keys_list(4), val: create_kw_n(4)],    do: kw_get(val, keys)
  bench "kw_get8",    [keys: create_keys_list(8), val: create_kw_n(8)],    do: kw_get(val, keys)
  bench "kw_get16",   [keys: create_keys_list(16), val: create_kw_n(16)],   do: kw_get(val, keys)
  bench "kw_get32",   [keys: create_keys_list(32), val: create_kw_n(32)],   do: kw_get(val, keys)

  bench "kw_get_unroll1",    [keys: create_keys_list(1), val: create_kw_n(1)],    do: kw_get_unroll(val, keys)
  bench "kw_get_unroll2",    [keys: create_keys_list(2), val: create_kw_n(2)],    do: kw_get_unroll(val, keys)
  bench "kw_get_unroll3",    [keys: create_keys_list(3), val: create_kw_n(3)],    do: kw_get_unroll(val, keys)
  bench "kw_get_unroll4",    [keys: create_keys_list(4), val: create_kw_n(4)],    do: kw_get_unroll(val, keys)
  bench "kw_get_unroll8",    [keys: create_keys_list(8), val: create_kw_n(8)],    do: kw_get_unroll(val, keys)
  bench "kw_get_unroll16",    [keys: create_keys_list(16), val: create_kw_n(16)],    do: kw_get_unroll(val, keys)
  bench "kw_get_unroll32",    [keys: create_keys_list(32), val: create_kw_n(32)],    do: kw_get_unroll(val, keys)

  bench "baseline1",    [keys: create_keys_list(1), val: create_kw_n(1)],    do: baseline(val, keys)
  bench "baseline2",    [keys: create_keys_list(2), val: create_kw_n(2)],    do: baseline(val, keys)
  bench "baseline3",    [keys: create_keys_list(3), val: create_kw_n(3)],    do: baseline(val, keys)
  bench "baseline4",    [keys: create_keys_list(4), val: create_kw_n(4)],    do: baseline(val, keys)
  bench "baseline8",    [keys: create_keys_list(8), val: create_kw_n(8)],    do: baseline(val, keys)
  bench "baseline16",   [keys: create_keys_list(16), val: create_kw_n(16)],   do: baseline(val, keys)
  bench "baseline32",   [keys: create_keys_list(32), val: create_kw_n(32)],   do: baseline(val, keys)

  bench "access_map64",     [keys: create_keys_list(64), val: create_map_n(64)],   do: access_map(val, keys)
  bench "access_map128",    [keys: create_keys_list(128), val: create_map_n(128)],   do: access_map(val, keys)
  bench "map_fetch64",      [keys: create_keys_list(64), val: create_map_n(64)],   do: map_fetch(val, keys)
  bench "map_fetch128",     [keys: create_keys_list(128), val: create_map_n(128)],   do: map_fetch(val, keys)
  bench "match64",          [keys: create_keys_list(64), val: create_map_n(64)],   do: match(val, keys)
  bench "match128",         [keys: create_keys_list(128), val: create_map_n(128)],   do: match(val, keys)
  bench "access_kw64",      [keys: create_keys_list(64), val: create_kw_n(64)],   do: access_kw(val, keys)
  bench "access_kw128",     [keys: create_keys_list(128), val: create_kw_n(128)],   do: access_kw(val, keys)
  bench "kw_get64",         [keys: create_keys_list(64), val: create_kw_n(64)],   do: kw_get(val, keys)
  bench "kw_get128",        [keys: create_keys_list(128), val: create_kw_n(128)],   do: kw_get(val, keys)
  bench "baseline64",       [keys: create_keys_list(64), val: create_kw_n(64)],   do: baseline(val, keys)
  bench "baseline128",      [keys: create_keys_list(128), val: create_kw_n(128)],   do: baseline(val, keys)
  bench "kw_get_unroll64",  [keys: create_keys_list(64), val: create_kw_n(64)],    do: kw_get_unroll(val, keys)
  bench "kw_get_unroll128", [keys: create_keys_list(128), val: create_kw_n(128)],    do: kw_get_unroll(val, keys)

end
