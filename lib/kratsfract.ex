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
      fn(z) -> Complex.julia(%Complex{}, z, 0, maxiter) end
    else
      fn(z) -> Complex.julia(z, %Complex{real: -0.75, imag: 0.14}, 0, maxiter) end
    end

    file = File.open! "foo.pgm", [:write]
    IO.binwrite file, "P5\n"
    IO.binwrite file, "#{width} #{height}\n"
    IO.binwrite file, "#{maxiter}\n"
    for row <- 0 .. height - 1, column <- 0 .. width - 1, into: [] do
      {column, row}
    end
    |> Stream.chunk(1200)
    |> Enum.map(fn chunk ->
      Task.async(fn ->
        for {column, row} <- chunk, do:
          c2v.(p2c.(column, row))
      end)
    end)
    |> Enum.map(&Task.await/1)
    |> (fn data -> IO.binwrite(file, data) end).()
    #   Task.async(fn ->
    #     c2v.(p2c.(column, row))
    #   end)
    # end
    # |> Enum.map(fn task -> Task.await(task) end)
    # 0 .. height - 1
    # |> Enum.map(fn row ->
    #   Task.async(fn ->
    #     0 .. width - 1
    #     |> Enum.map(fn column ->
    #       column |> p2c.(row) |> c2v.()
    #     end)
    #   end)
    # end)
    # |> Enum.map(fn task -> Task.await(task) end)
    # |> (fn data -> IO.binwrite(file, data) end).()
  end

  defp calculate_row({column, row}, c2v, p2c) do
    c2v.(p2c.(column, row))
  end

  @doc "Create a transform for image coordinates to complex number"
  def makeTransform(width, height, scale) do
    w_2 = div width, 2
    h_2 = div height, 2
    s = scale / min(w_2, h_2)
    fn(x, y) -> %Complex{real: s * (x - w_2), imag: s * (y - h_2)} end
  end
end
