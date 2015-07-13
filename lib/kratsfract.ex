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
    schedulers = :erlang.system_info(:schedulers_online)
    lines_per_scheduler = div(height, schedulers)

    file = File.open! "foo.pgm", [:write]
    IO.binwrite file, "P5\n"
    IO.binwrite file, "#{width} #{height}\n"
    IO.binwrite file, "#{maxiter}\n"

    for i <- 1 .. schedulers do
      Task.async(fn ->
        low = lines_per_scheduler * (i - 1)
        high = low + lines_per_scheduler - 1
        for row <- low .. high, column <- 0 .. width - 1 do
          apply(__MODULE__,
                compute_function,
                [{s * (column - w_2), s * (row - h_2)}, maxiter])
        end
      end)
    end
    |> Enum.map(&Task.await/1)
    |> (fn data -> IO.binwrite(file, data) end).()
  end

  def compute_mandelbrot(n, maxiter) do
    Fractal.julia({0.0, 0.0}, n, 0, maxiter)
  end

  def compute_julia(n, maxiter) do
    Fractal.julia(n, {-0.75, 0.14}, 0, maxiter)
  end
end
