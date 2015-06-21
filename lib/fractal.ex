defmodule Fractal do
  def julia(_z, _c, i, max_i) when i > max_i,
    do: 0
  def julia({re, im}, _, i, _) when re * re + im * im < -4,
    do: i
  def julia({re, im}, _, i, _) when re * re + im * im > 4,
    do: i
  def julia({re1, im1}, {re2, im2} = c, i, max_i) do
    julia({re1 * re1 - im1 * im1 + re2, 2 * re1 * im1 + im2}, c, i + 1, max_i)
  end
end
