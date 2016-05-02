defmodule Plex.Compiler.Node.Apply do
  @moduledoc "Function application"

  alias __MODULE__
  alias Plex.{Compiler, Env}
  alias Plex.Compiler.Closure
  alias Plex.Compiler.Node.Function

  @type t :: %__MODULE__{
            line: integer,
            applicant: Plex.Compiler.Node.t,
            args: Plex.Compiler.Node.t
        }

  defstruct [
    :line,
    :applicant,
    :args
  ]

  defimpl Plex.Compiler.Node do
    def eval(%Apply{applicant: {:identifier, _line, name}, args: args}, env) do
      term = Env.get!(env, name)
      args = Enum.map(args, &(Compiler.eval(&1, env)))

      case term do
        # TODO: check for correct arity
        %Closure{value: closure} -> apply(closure, [args])
        func -> apply(func, args)
      end
    end

    def eval(%Apply{applicant: %Function{body: body, params: params}, args: args}, env) do
      args = Enum.map(args, &(Compiler.eval(&1, env)))
      apply_function(body, params, args, env)
    end

    defp apply_function(body, params, args, env) do
      bindings = Enum.zip(params, args) |> Enum.into(%{})
      local_scope = Env.new(env, bindings)
      Compiler.eval(body, local_scope)
    end
  end
end
