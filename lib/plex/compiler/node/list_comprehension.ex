defmodule Plex.Compiler.Node.ListComprehension do
  @moduledoc "List comprehensions"

  alias Plex.Compiler

  @type t :: %__MODULE__{
            line: integer,
            binding: atom,
            output_expr: Compiler.Node.t,
            generator: Compiler.Node.t,
            guard: Compiler.Node.Function.t
        }

  defstruct [
    :line,
    :binding,
    :output_expr,
    :generator,
    :guard
  ]
end
