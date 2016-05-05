defmodule Plex.Compiler.Node.Case do
  @moduledoc "Case expressions"

  alias __MODULE__
  alias Plex.{Compiler, Env}
  alias Plex.Compiler.Node.Case

  @type t :: %__MODULE__{
            line: integer,
            expr: Compiler.Node.t,
            clauses: list(Compiler.Node.t)
        }

  defstruct [
    :line,
    :expr,
    :clauses
  ]

  defimpl Plex.Compiler.Node do
    def eval(%Case{expr: expr, clauses: clauses}, env) do
      env = Env.new(env)
      expr_result = Compiler.eval(expr, env)

      case_result =
        Enum.reduce_while(clauses, {nil, expr_result, env},
          fn clause, {result, expr_result, env} = acc ->
            patterns = Enum.map(clause.patterns, &(Compiler.eval(&1, env)))
            if expr_result in patterns do
              result = Compiler.eval(clause.exprs, env)
              {:halt, {result, expr_result, env}}
            else
              {:cont, acc}
            end
          end)

      # return the result, first element in the accumulator
      elem(case_result, 0)
    end
  end
end

defmodule Plex.Compiler.Node.Clause do
  @moduledoc "Case clause, expressions"

  alias Plex.Compiler

  @type t :: %__MODULE__{
            line: integer,
            patterns: list(Compiler.Node.t),
            exprs: list(Compiler.Node.t)

        }

  defstruct [
    :line,
    :patterns,
    :exprs
  ]
end
