defmodule Plex.Compiler.Node.BinaryOp do
  @moduledoc "Binary operations"

  @type t :: %__MODULE__{
            line: integer,
            type: atom,
            left: any,
            right: any,
        }

  defstruct [
    :line,
    :type,
    :left,
    :right
  ]
end
