defmodule Plex.Compiler.Node.Let do
  @moduledoc "Let bindings"
  # bindings can be {term, value, with_block} OR {term, value}

  @type t :: %__MODULE__{
            line: integer,
            bindings: atom,
            in_block: any,
        }

  defstruct [
    :line,
    :bindings,
    :in_block
  ]
end
