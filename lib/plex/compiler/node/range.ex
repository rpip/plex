defmodule Plex.Compiler.Node.Range do
  @moduledoc "Range expresssions, for example `0..10`"

  alias __MODULE__
  alias Plex.Compiler

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

  defimpl Plex.Compiler.Node do
    def eval(%Range{from: from, to: to}, env) do
      from = Compiler.eval(from, env)
      to = Compiler.eval(to, env)

      Kernel.'..'(from, to)
    end
  end
end
