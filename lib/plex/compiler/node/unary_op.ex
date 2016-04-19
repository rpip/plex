defmodule Plex.Compiler.Node.UnaryOp do
  @moduledoc "Unary operations"

  @type t :: %__MODULE__{
            line: integer,
            type: atom,
            arg: any
        }

  defstruct [
    :line,
    :type,
    :arg
  ]
end
