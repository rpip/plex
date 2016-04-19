defmodule Plex.Compiler.Node.List do
  @moduledoc "List data type"

  @type t :: %__MODULE__{
            line: integer,
            elements: list,
        }

  defstruct [
    :line,
    :elements
  ]
end
