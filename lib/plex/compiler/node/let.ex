defmodule Plex.Compiler.Node.ValueFunc do
  @moduledoc """
  Value with functions attached.

  This type of value can be used as plain values and in function application.
  """

  alias __MODULE__
  alias Plex.Compiler

  defstruct [
    :value,
    :function
  ]

  defimpl Plex.Compiler.Node do
    def eval(%ValueFunc{value: value}, _env) do
      IO.puts "ValueFunc: #{value}"
      value
    end
  end
end


defmodule Plex.Compiler.Node.Let do
  @moduledoc """
  Let bindings

  Bindings can be {term, value, with_block} OR {term, value}
  """
  alias __MODULE__
  alias Plex.{Compiler, Env}
  alias Plex.Compiler.Node.ValueFunc

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
        {k, v, {:with_function, func}} ->
          val = Compiler.eval(v, env)
          func = Compiler.eval(func, env)
          val_func = %ValueFunc{value: val, function: func}
          Env.bind(env, k, val_func);
      end)
    end
  end
end
