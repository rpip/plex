defmodule Plex.Compiler.Node.Apply do
  @moduledoc "Function application"
  alias __MODULE__
  alias Plex.{Compiler, Env}

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
    def eval(%Apply{applicant: {:identifier, _line, name}, args: []}, env) do
      Env.get!(env, name).()
    end

    def eval(%Apply{applicant: {:identifier, _line, name}, args: args}, env) do
      func = Env.get!(env, name)
      args = Compiler.eval(args, env)

      func.(args)
    end
  end
end
