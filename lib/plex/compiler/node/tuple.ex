defmodule Plex.Compiler.Node.Tuple do
  @moduledoc "Tuple data type"

  @type t :: %__MODULE__{
            line: integer,
            elements: list
        }

  defstruct [
    :line,
    :elements
  ]
end
