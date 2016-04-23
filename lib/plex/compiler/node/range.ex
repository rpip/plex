defmodule Plex.Compiler.Node.Range do
  @moduledoc "Range expresssions, for example `0..10`"

  @type t :: %__MODULE__{
            line: integer,
            from: integer,
            to: integer
        }

  defstruct [
    :line,
    :from,
    :to
  ]
end
