defmodule Plex.Compiler.Node.BinaryOp do
  @moduledoc "Binary operations"
  alias __MODULE__
  alias Plex.{Env, Compiler}

  @type t :: %__MODULE__{
            line: integer,
            type: atom,
            left: any,
            right: any,
        }

  defstruct [
    :line,
    :type,
    :left,
    :right
  ]

  defimpl Plex.Compiler.Node do
    def eval(%BinaryOp{left: left, right: right, type: :=}, env) do
      key = Compiler.eval(left, env)
      val = Compiler.eval(right, env)
      # match left against right
      val = Env.get!(key)
    end

    def eval(%BinaryOp{left: left, right: right, type: :and}, env) do
      Compiler.eval(left, env) and Compiler.eval(right, env)
    end

    def eval(%BinaryOp{left: left, right: right, type: :or}, env) do
      Compiler.eval(left, env) or Compiler.eval(right, env)
    end

    # comparison ops
    def eval(%BinaryOp{left: left, right: right, type: :==}, env) do
      Compiler.eval(left, env) == Compiler.eval(right, env)
    end

    def eval(%BinaryOp{left: left, right: right, type: :!=}, env) do
      Compiler.eval(left, env) != Compiler.eval(right, env)
    end

    def eval(%BinaryOp{left: left, right: right, type: :>}, env) do
      Compiler.eval(left, env) > Compiler.eval(right, env)
    end

    def eval(%BinaryOp{left: left, right: right, type: :<}, env) do
      Compiler.eval(left, env) < Compiler.eval(right, env)
    end

    def eval(%BinaryOp{left: left, right: right, type: :>=}, env) do
      Compiler.eval(left, env) >= Compiler.eval(right, env)
    end

    def eval(%BinaryOp{left: left, right: right, type: :<=}, env) do
      Compiler.eval(left, env) <= Compiler.eval(right, env)
    end

    # addition ops
    def eval(%BinaryOp{left: left, right: right, type: :+}, env) do
      Compiler.eval(left, env) + Compiler.eval(right, env)
    end

    def eval(%BinaryOp{left: left, right: right, type: :-}, env) do
      Compiler.eval(left, env) - Compiler.eval(right, env)
    end

    # multiplication ops
    def eval(%BinaryOp{left: left, right: right, type: :*}, env) do
      Compiler.eval(left, env) * Compiler.eval(right, env)
    end

    def eval(%BinaryOp{left: left, right: right, type: :/}, env) do
      Compiler.eval(left, env) / Compiler.eval(right, env)
    end

    def eval(%BinaryOp{left: left, right: right, type: :%}, env) do
      Compiler.eval(left, env)
      |> rem(Compiler.eval(right, env))
    end

    def eval(%BinaryOp{left: left, right: right, type: :^}, env) do
      Compiler.eval(left, env)
      |> :math.pow(Compiler.eval(right, env))
    end
  end
end
