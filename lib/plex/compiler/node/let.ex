defmodule Plex.Compiler.Node.Let do
  @moduledoc "Let bindings"

  @type t :: %__MODULE__{
            line: integer,
            name: atom,
            value: any,
            with_block: any,
            in_block: any,
        }

  defstruct [
    :line,
    :name,
    :value,
    :with_block,
    :in_block
  ]
end
