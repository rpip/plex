defmodule Plex.Compiler.Node.UpdateRef do
  @moduledoc "Update a reference"

  alias __MODULE__
  alias Plex.Types.Ref
  alias Plex.Compiler.Node.Project
  alias Plex.{Env, Compiler}

  @type t :: %__MODULE__{
            line: integer,
            ref: atom,
            value: any
        }

  defstruct [
    :line,
    :ref,
    :value
  ]

  defimpl Plex.Compiler.Node do
    def eval(%UpdateRef{ref: {:identifier, _, ref}, value: val}, env) do
      ref_pid = Env.get!(env, ref)
      new_val = Compiler.eval(val, env)

      Ref.update(ref_pid, new_val)
    end

    def eval(%UpdateRef{ref: %Project{} = project, value: val}, env) do
      ref_pid = Compiler.eval(project, env)
      new_val = Compiler.eval(val, env)

      Ref.update(ref_pid, new_val)
    end
  end
end
