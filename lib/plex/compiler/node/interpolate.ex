defmodule Plex.Compiler.Node.Interpolate do
  @moduledoc "String interpolation"

  @type t :: %__MODULE__{
            line: integer,
            body: any
        }

  defstruct [
    :line,
    :body
  ]
end
