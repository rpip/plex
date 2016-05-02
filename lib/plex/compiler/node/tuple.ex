defmodule Plex.Compiler.Node.Tuple do
  @moduledoc "Tuple data type"

  alias __MODULE__
  alias Plex.Compiler

  @type t :: %__MODULE__{
            line: integer,
            elements: list
        }

  defstruct [
    :line,
    :elements
  ]

  defimpl Plex.Compiler.Node do
    def eval(%Tuple{elements: elems}, env) do
      Enum.map(elems, &(Compiler.eval(&1, env)))
      |> List.to_tuple
    end
  end
end
