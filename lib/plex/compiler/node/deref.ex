defmodule Plex.Compiler.Node.Deref do
  @moduledoc "Deferencing"

  alias __MODULE__
  alias Plex.Types.Ref
  alias Plex.Env
  import Plex.Utils, only: [unwrap: 1]

  @type t :: %__MODULE__{
            line: integer,
            ref: atom
        }

  defstruct [
    :line,
    :ref
  ]

  defimpl Plex.Compiler.Node do
    def eval(%Deref{ref: ref}, env) do
      ref = unwrap(ref)
      Env.get!(env, ref)
      |> Ref.deref
    end
  end
end
