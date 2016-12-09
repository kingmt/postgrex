defmodule GeometryQueryTest do
  use ExUnit.Case, async: true
  import Postgrex.TestHelper
  alias Postgrex, as: P

  setup context do
    opts = [ database: "postgrex_test", backoff_type: :stop,
             prepare: context[:prepare] || :named]
    {:ok, pid} = P.start_link(opts)
    {:ok, [pid: pid, options: opts]}
  end

  test "decode point", context do
    assert [[%Postgrex.Point{x: -97.5, y: 100.1}]] == query("SELECT point(-97.5, 100.1)::point", [])
  end

  test "encode point", context do
    assert [[%Postgrex.Point{x: -97.0, y: 100.0}]] == query("SELECT $1::point", [%Postgrex.Point{x: -97, y: 100}])
  end

  test "decode circle", context do
    assert [[%Postgrex.Circle{center: %Postgrex.Point{x: -97.5, y: 100.1}, radius: 1.2}]] ==
      query("SELECT '-97.5, 100.1, 1.2'::circle", [])
  end

  test "encode circle", context do
    assert [[%Postgrex.Circle{center: %Postgrex.Point{x: -97.0, y: 100.0}, radius: 1.2}]] ==
      query("SELECT $1::circle", [%Postgrex.Circle{center: %Postgrex.Point{x: -97, y: 100}, radius: 1.2}])
  end

  test "encode line with only points", context do
    assert [[%Postgrex.Line{a_point: %Postgrex.Point{x: -97.0, y: 100.0}, b_point: %Postgrex.Point{x: 22, y: 23}}]] ==
      query("SELECT $1::line", [%Postgrex.Line{a_point: %Postgrex.Point{x: -97, y: 100}, b_point: %Postgrex.Point{x: 22, y: 23}}])
  end

  test "encode line with a, b, c", context do
    assert [[%Postgrex.Line{a: -8, b: -1.0, c: 22.4}]] ==
      query("SELECT $1::line", [%Postgrex.Line{a: -8, b: -1.0, c: 22.4}])
  end

  test "decode line", context do
    assert [[%Postgrex.Line{a: -0.7954337899543379, b: -1.0, c: 22.54520547945205}]] ==
      query("SELECT '-97.5, 100.1, 12, 13'::line", [])
  end

  test "decode lseg", context do
    assert [[%Postgrex.Lseg{a: %Postgrex.Point{x: -97.5, y: 100.1}, b: %Postgrex.Point{x: 12, y: 13}}]] ==
      query("SELECT '-97.5, 100.1, 12, 13'::lseg", [])
  end

  test "encode lseg", context do
    assert [[%Postgrex.Lseg{a: %Postgrex.Point{x: -97.0, y: 100.0}, b: %Postgrex.Point{x: 22, y: 23}}]] ==
      query("SELECT $1::lseg", [%Postgrex.Lseg{a: %Postgrex.Point{x: -97, y: 100}, b: %Postgrex.Point{x: 22, y: 23}}])
  end

  test "decode box", context do
    assert [[%Postgrex.Box{a: %Postgrex.Point{x: 12, y: 100.1}, b: %Postgrex.Point{x: -97.5, y: 13}}]] ==
      query("SELECT '12.0, 100.1, -97.5, 13.0'::box", [])
  end

  test "encode box with top right and bottom left corners", context do
    assert [[%Postgrex.Box{a: %Postgrex.Point{x: 22, y: 100.0}, b: %Postgrex.Point{x: -97.0, y: 23}}]] ==
      query("SELECT $1::box", [%Postgrex.Box{a: %Postgrex.Point{x: -97, y: 100}, b: %Postgrex.Point{x: 22, y: 23}}])
  end

  test "encode box with top left and bottom right corners", context do
    assert [[%Postgrex.Box{a: %Postgrex.Point{x: 22, y: 100.0}, b: %Postgrex.Point{x: -97.0, y: 23}}]] ==
      query("SELECT $1::box", [%Postgrex.Box{a: %Postgrex.Point{x: 22, y: 100}, b: %Postgrex.Point{x: -97, y: 23}}])
  end
end
