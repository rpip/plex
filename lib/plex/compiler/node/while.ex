defmodule Plex.Compiler.Node.While do
  @moduledoc "While loops"

  @type t :: %__MODULE__{
            line: integer,
            condition: any,
            body: any
        }

  defstruct [
    :line,
    :condition,
    :body
  ]
end
