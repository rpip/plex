defmodule Plex.Compiler.Node.Function do
  @moduledoc "Function defs"

  @type t :: %__MODULE__{
            line: integer,
            args: list,
            body: any
        }

  defstruct [
    :line,
    :args,
    :body
  ]
end
