defmodule Plex.Compiler.Node.Deref do
  @moduledoc "Deferencing"

  alias __MODULE__
  alias Plex.Types.Ref
  alias Plex.Compiler.Node.Project
  alias Plex.Env

  @type t :: %__MODULE__{
            line: integer,
            ref: atom
        }

  defstruct [
    :line,
    :ref
  ]

  defimpl Plex.Compiler.Node do
    def eval(%Deref{ref: {:identifier, _, ref}}, env) do
      Env.get!(env, ref)
      |> Ref.deref
    end

    def eval(%Deref{ref: %Project{} = project}, env) do
      Plex.Compiler.eval(project, env)
      |> Ref.deref
    end
  end
end
