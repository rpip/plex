defmodule Plex.Compiler.Node.Range do
  @moduledoc "Range expresssions, for example `0..10`"

  @type t :: %__MODULE__{
            line: integer,
            first: integer,
            last: integer
        }

  defstruct [
    :line,
    :first,
    :last
  ]
end
