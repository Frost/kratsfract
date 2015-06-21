defmodule KratsFract do

  def main(argv) do
    {options, [], []} = OptionParser.parse(argv,
              strict: [width: :integer, height: :integer, scale: :float,
                       mandelbrot: :boolean])
    width = options[:width] || 800 # 1920
    height = options[:height] || 600 # 1080
    scale = options[:scale] || 1.2
    compute_function = if options[:mandelbrot] do
      :compute_mandelbrot
    else
      :compute_julia
    end

    maxiter = 255

    w_2 = div width, 2
    h_2 = div height, 2
    s = scale / min(w_2, h_2)

    file = File.open! "foo.pgm", [:write]
    IO.binwrite file, "P5\n"
    IO.binwrite file, "#{width} #{height}\n"
    IO.binwrite file, "#{maxiter}\n"
    for row <- 0 .. height - 1, column <- 0 .. width - 1 do
      {column, row}
    end
    |> Stream.chunk(4000)
    |> Enum.map(fn chunk ->
      Task.async(__MODULE__, compute_function, [w_2, h_2, s, chunk, maxiter])
    end)
    |> Enum.map(&Task.await/1)
    |> (fn data -> IO.binwrite(file, data) end).()
  end

  def compute_mandelbrot(w_2, h_2, s, chunk, maxiter) do
    for {column, row} <- chunk, do:
      Fractal.julia({0.0, 0.0},
                    {s * (column - w_2), s * (row - h_2)},
                    0,
                    maxiter)
  end

  def compute_julia(w_2, h_2, s, chunk, maxiter) do
    for {column, row} <- chunk, do:
      Fractal.julia({s * (column - w_2), s * (row - h_2)},
                    {-0.75, 0.14},
                    0,
                    maxiter)
  end
end
