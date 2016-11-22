defmodule Postgrex.Extensions.Box do
  @moduledoc false
  import Postgrex.BinaryUtils
  use Postgrex.BinaryExtension, send: "box_send"

  def encode(_, %Postgrex.Box{a: %Postgrex.Point{x: x, y: y}, b: %Postgrex.Point{x: x1, y: y1}}, _, _),
    do: <<x::float64, y::float64, x1::float64, y1::float64>>

  def encode(type_info, value, _, _) do
    raise ArgumentError,
      Postgrex.Utils.encode_msg(type_info, value, Postgrex.Box)
  end

  def decode(_, <<x::float64, y::float64, x1::float64, y1::float64>>, _, _),
    do: %Postgrex.Box{a: %Postgrex.Point{x: x, y: y}, b: %Postgrex.Point{x: x1, y: y1}}
end
