defmodule Plex do
  @spec parse(binary) :: {:ok, list} | {:error, term}
  def parse(text) do
    Plex.Compiler.parse!(text)
  end

  defmodule CLI do
    @moduledoc "Plex command line script"

    def main([]), do: Plex.Repl.run

    def main([file|_]) do
      path = Path.absname(file)

      File.read!(path)
      |> Plex.parse
      |> inspect
      |> IO.puts
    end
  end
end
