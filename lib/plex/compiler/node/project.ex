defmodule Plex.Compiler.Node.Project do
  @moduledoc "Project of object attribute, for example: `person.name`"

  alias __MODULE__
  alias Plex.Compiler

  @type t :: %__MODULE__{
            line: integer,
            object: any,
            field: any
        }

  defstruct [
    :line,
    :object,
    :field
  ]

  defimpl Plex.Compiler.Node do
    def eval(%Project{object: object, field: field}, env) do
      object = Compiler.eval(object, env)
      case Map.fetch(object, field) do
        {:ok, val} ->
          val
        :error ->
          {:error, "key #{field} not found in #{inspect object}"}
      end
    end
  end
end
