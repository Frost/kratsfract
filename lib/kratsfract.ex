defmodule KratsFract do

  def main(argv) do
    {options, [], []} = OptionParser.parse(argv,
              strict: [width: :integer, height: :integer, scale: :float,
                       mandelbrot: :boolean])
    width = options[:width] || 800 # 1920
    height = options[:height] || 600 # 1080
    maxiter = 255

    p2c = makeTransform(width, height, options[:scale] || 1.2)
    c2v = if options[:mandelbrot] do
      fn(z) -> Complex.julia({0.0, 0.0}, z, 0, maxiter) end
    else
      fn(z) -> Complex.julia(z, {-0.75, 0.14}, 0, maxiter) end
    end

    file = File.open! "foo.pgm", [:write]
    IO.binwrite file, "P5\n"
    IO.binwrite file, "#{width} #{height}\n"
    IO.binwrite file, "#{maxiter}\n"
    IO.binwrite file, (for row <- 0..height-1,
                           column <- 0..width-1,
                       do: c2v.(p2c.(column, row)))
  end

  @doc "Create a transform for image coordinates to complex number"
  def makeTransform(width, height, scale) do
    w_2 = div width, 2
    h_2 = div height, 2
    s = scale / min(w_2, h_2)
    fn(x, y) -> {s * (x - w_2), s * (y - h_2)} end
  end
end
