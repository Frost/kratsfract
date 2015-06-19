defmodule Complex do
  @moduledoc "Working with complex numbers."

  defstruct real: 0.0, imag: 0.0

  def abs(re, im) do
      :math.pow(re*re + im*im, 0.5)
  end

  @doc "The absolute value of a complex number"
  def zabs(z) do
      :math.pow(z.real*z.real + z.imag*z.imag, 0.5)
  end

  @doc "The square of abs(z), to avoid calculating the root"
  def zabs2(z) do
      z.real*z.real + z.imag*z.imag
  end

  def sqr(z) do
    %{real: z.real * z.real - z.imag * z.imag,
      imag: 2 * z.real * z.imag}
  end

  def plus(z1, z2) do
    %{real: z1.real + z2.real, imag: z1.imag + z2.imag}
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



