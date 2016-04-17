defmodule Plex do
  @spec parse(binary) :: {:ok, list} | {:error, term}
  def parse(text) do
    Plex.Compiler.parse!(text)
  end
end
