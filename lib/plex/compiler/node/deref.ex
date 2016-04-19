defmodule Plex.Compiler.Node.Deref do
  @moduledoc "Deferencing"

  @type t :: %__MODULE__{
            line: integer,
            name: atom
        }

  defstruct [
    :line,
    :name
  ]
end
