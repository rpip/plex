defmodule Plex.Compiler.Node.Case do
  @moduledoc "Case expressions"

  @type t :: %__MODULE__{
            line: integer,
            expr: any,
            clauses: list
        }

  defstruct [
    :line,
    :expr,
    :clauses
  ]
end
