defmodule Complex do
  @moduledoc "Working with complex numbers."

  @doc "The absolute value of a complex number"
  def zabs({real, imag}) when is_float(real) and is_float(imag) do
      :math.pow(real * real + imag * imag, 0.5)
  end

  @doc "The square of abs(z), to avoid calculating the root"
  def zabs2({real, imag}) when is_float(real) and is_float(imag) do
      real*real + imag*imag
  end

  def sqr({real, imag}) when is_float(real) and is_float(imag)  do
    {real * real - imag * imag, 2 * real * imag}
  end

  def plus({real1, imag1}, {real2, imag2})  when is_float(real1) and is_float(imag1) and is_float(real2) and is_float(imag2) do
    {real1 + real2, imag1 + imag2}
  end

  def julia(_z, _c, i, max_i) when i > max_i do
    0
  end

  def julia(z, c, i, max_i) when i <= max_i do
    if zabs2(z) > 4,
      do: i,
      else: julia(plus(sqr(z), c), c, i + 1, max_i)
  end

end
