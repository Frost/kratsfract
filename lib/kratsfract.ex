defmodule KratsFract do

  def main(argv) do
    {options, [], []} = OptionParser.parse(argv,
              strict: [width: :integer, height: :integer, scale: :float,
                       mandelbrot: :boolean])
    width = options[:width] || 800 # 1920
    height = options[:height] || 600 # 1080
    scale = options[:scale] || 1.2
    maxiter = 255

    p2c = fn(x, y) ->
      aspect = width / height
      w_2 = div width, 2
      h_2 = div height, 2
      %Complex{real: scale * aspect * (x - w_2) / w_2,
               imag: scale * (y - h_2) / h_2}
    end
    c2v = if options[:mandelbrot] do
      fn(z) -> Complex.julia(%Complex{}, z, 0, maxiter) end
    else
      fn(z) -> Complex.julia(z, %Complex{real: -0.75, imag: 0.14}, 0, maxiter) end
    end

    file = File.open! "foo.pgm", [:write]
    IO.binwrite file, "P5\n"
    IO.binwrite file, "#{width} #{height}\n"
    IO.binwrite file, "#{maxiter}\n"
    IO.binwrite file, (for row <- 0..height-1,
                           column <- 0..width-1,
                       do: c2v.(p2c.(column, row)))
  end
end
