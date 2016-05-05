defmodule Plex.Compiler.Node.Let do
  @moduledoc """
  Let bindings

  Bindings can be {term, value, with_block} OR {term, value}
  """
  alias __MODULE__
  alias Plex.{Compiler, Env}

  @type t :: %__MODULE__{
            line: integer,
            bindings: atom,
            in_block: any,
        }

  defstruct [
    :line,
    :bindings,
    :in_block
  ]

  defimpl Plex.Compiler.Node do
    def eval(%Let{bindings: bindings, in_block: nil}, env) do
      do_let_bindings(bindings, env)
    end

    def eval(%Let{bindings: bindings, in_block: in_block}, env) do
      local_scope = Env.new(env)
      do_let_bindings(bindings, local_scope)

      Compiler.eval(in_block, local_scope)
    end

    defp do_let_bindings(bindings, env) do
      Enum.map(bindings, fn {k, v} ->
          val = Compiler.eval(v, env)
          Env.bind(env, k, val)
          val;
        # TODO: implement `with_clause`
        {k, v, _with_clause} ->
          val = Compiler.eval(v, env)
          Env.bind(env, k, val);
      end)
    end
  end
end
