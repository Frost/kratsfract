defmodule Complex do
  @moduledoc "Working with complex numbers."

  defstruct real: 0.0, imag: 0.0

  defmacro abs(re, im) do
    quote bind_quoted: [re: re, im: im] do
      :math.pow(re * re + im * im, 0.5)
    end
  end

  @doc "The absolute value of a complex number"
  defmacro zabs(z) do
    quote bind_quoted: [z: z] do
      :math.pow(z.real * z.real + z.imag * z.imag, 0.5)
    end
  end

  @doc "The square of abs(z), to avoid calculating the root"
  defmacro zabs2(z) do
    quote bind_quoted: [z: z] do
      z.real * z.real + z.imag * z.imag
    end
  end

  defmacro sqr(z) do
    quote bind_quoted: [z: z] do
      %Complex{real: z.real * z.real - z.imag * z.imag,
               imag: 2 * z.real * z.imag}
    end
  end

  defmacro plus(z1, z2) do
    quote bind_quoted: [z1: z1, z2: z2] do
      %Complex{real: z1.real + z2.real, imag: z1.imag + z2.imag}
    end
  end

  def julia(_z, _c, i, max_i) when i > max_i,
    do: 0
  def julia(%{real: real, imag: imag}, _, i, _) when real*real + imag*imag < -4,
    do: i
  def julia(%{real: real, imag: imag}, _, i, _) when real*real + imag*imag > 4,
    do: i
  def julia(z, c, i, max_i),
    do: julia(plus(sqr(z), c), c, i + 1, max_i)
end
