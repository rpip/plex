defmodule Plex.Compiler.Node.If do
  @moduledoc "IF expressions"

  @type t :: %__MODULE__{
            line: integer,
            condition: any,
            then_block: any,
            else_block: any
        }

  defstruct [
    :line,
    :condition,
    :then_block,
    :else_block
  ]
end
