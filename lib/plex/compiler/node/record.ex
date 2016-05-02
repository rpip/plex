defmodule Plex.Compiler.Node.Record do
  @moduledoc "Record data structures"

  alias __MODULE__
  alias Plex.Compiler

  @type t :: %__MODULE__{line: integer, properties: list}

  defstruct [
    :line,
    :properties
  ]

  defimpl Plex.Compiler.Node do
    def eval(%Record{properties: props}, env) do
      Enum.map(props, fn {k, v} -> {k, Compiler.eval(v, env)} end)
      |> Enum.into(%{})
    end
  end
end
