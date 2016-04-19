defmodule Plex.Compiler.Node.For do
  @moduledoc "For loops"

  @type t :: %__MODULE__{
            line: integer,
            var: atom,
            generator: any,
            body: any
        }

  defstruct [
    :line,
    :var,
    :generator,
    :body
  ]
end
