defmodule Plex.Compiler.Node.If do
  @moduledoc "IF expressions"

  alias __MODULE__
  alias Plex.Compiler

  @type t :: %__MODULE__{
            line: integer,
            condition: any,
            then_block: any,
            else_block: any
        }

  defstruct [
    :line,
    :condition,
    :then_block,
    :else_block
  ]

  defimpl Plex.Compiler.Node do
    def eval(%If{condition: condition, then_block: then_block, else_block: nil}, env) do
      if Compiler.eval(condition, env) do
        Compiler.eval(then_block, env)
    end
  end

    def eval(%If{condition: condition, then_block: then_block, else_block: else_block}, env) do
      if Compiler.eval(condition, env) do
        Compiler.eval(then_block, env)
      else
        Compiler.eval(else_block, env)
      end
    end
  end
end
