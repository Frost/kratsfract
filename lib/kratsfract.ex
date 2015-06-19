defmodule KratsFract do

  def main(_args) do
    width = 800 # 1920
    height = 600 # 1080
    maxiter = 255

    p2c = fn(x, y) ->
      aspect = width / height
      w_2 = div width, 2
      h_2 = div height, 2
      %{real: aspect * (x - w_2) / w_2, imag: (y - h_2) / h_2}
    end

    file = File.open! "foo.pgm", [:write]
    IO.binwrite file, "P5\n"
    IO.binwrite file, "#{width} #{height}\n"
    IO.binwrite file, "#{maxiter}\n"
    IO.binwrite file, Enum.map(0..height-1, fn(row) ->
      for column <- 0..width-1  do
        Complex.julia(p2c.(column, row), %{real: -0.75, imag: 0.14}, 0, maxiter)
        # Complex.julia(%{real: 0, imag: 0}, p2c.(column, row), 0, maxiter)
      end
    end)
    IO.binwrite file, "\n"
  end
end
