defmodule Plex.Compiler.Node.UpdateRef do
  @moduledoc "Update a reference"

  @type t :: %__MODULE__{
            line: integer,
            name: atom,
            value: any
        }

  defstruct [
    :line,
    :name,
    :value
  ]
end
