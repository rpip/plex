defmodule Plex.Compiler.Node.UpdateRef do
  @moduledoc "Update a reference"

  alias __MODULE__
  alias Plex.Types.Ref
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
    def eval(%UpdateRef{ref: ref, value: val}, env) do
      new_val = Compiler.eval(val, env)

      Env.get!(env, ref)
      |> Ref.update(new_val)
    end
  end
end
