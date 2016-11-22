defmodule Postgrex.Extensions.Circle do
  @moduledoc false
  import Postgrex.BinaryUtils
  use Postgrex.BinaryExtension, send: "circle_send"

  def encode(_, %Postgrex.Circle{center: %Postgrex.Point{x: x, y: y}, radius: radius}, _, _),
    do: <<x::float64, y::float64, radius::float64>>

  def encode(type_info, value, _, _) do
    raise ArgumentError,
      Postgrex.Utils.encode_msg(type_info, value, Postgrex.Circle)
  end

  def decode(_, <<x::float64, y::float64, radius::float64>>, _, _),
    do: %Postgrex.Circle{center: %Postgrex.Point{x: x, y: y}, radius: radius}
end
