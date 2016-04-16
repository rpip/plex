defmodule Plex do
  defmodule Parser do
    @moduledoc """
    Parses text and transaltes into Elixir data structures
    """
    @spec parse(binary) :: {:ok, list} | {:error, term}
    def parse(str) do
      {:ok, tokens, _} = str |> to_char_list |> :plex_scan.string

      case tokens do
        [] -> {:ok, []}
        _ -> :plex_parse.parse(tokens)
      end
    end
  end
end
