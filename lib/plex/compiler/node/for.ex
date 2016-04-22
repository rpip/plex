defmodule Plex.Compiler.Node.For do
  @moduledoc "For loops"

  @type t :: %__MODULE__{
            line: integer,
            term: atom,
            generator: any,
            body: any
        }

  defstruct [
    :line,
    :term,
    :generator,
    :body
  ]
end
