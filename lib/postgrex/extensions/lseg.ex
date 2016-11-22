defmodule Postgrex.Extensions.Lseg do
  @moduledoc false
  import Postgrex.BinaryUtils
  use Postgrex.BinaryExtension, send: "lseg_send"

  def encode(_, %Postgrex.Lseg{a: %Postgrex.Point{x: x, y: y}, b: %Postgrex.Point{x: x1, y: y1}}, _, _),
    do: <<x::float64, y::float64, x1::float64, y1::float64>>

  def encode(type_info, value, _, _) do
    raise ArgumentError,
      Postgrex.Utils.encode_msg(type_info, value, Postgrex.Lseg)
  end

  def decode(_, <<x::float64, y::float64, x1::float64, y1::float64>>, _, _),
    do: %Postgrex.Lseg{a: %Postgrex.Point{x: x, y: y}, b: %Postgrex.Point{x: x1, y: y1}}
end
