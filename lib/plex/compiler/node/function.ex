defmodule Plex.Compiler.Node.Function do
  @moduledoc "Function defs"

  @type t :: %__MODULE__{
            line: integer,
            params: list,
            body: any
        }

  defstruct [
    :line,
    :params,
    :body
  ]
end
