defmodule Plex.Compiler.Node.Interpolate do
  @moduledoc "String interpolation"

  alias __MODULE__
  alias Plex.Env

  @type t :: %__MODULE__{
            line: integer,
            body: any
        }

  defstruct [
    :line,
    :body
  ]

  defimpl Plex.Compiler.Node do
    def eval(%Interpolate{body: {:string_interpolate, _line, str}}, env) do
      Env.get!(env, :eval).(str)
    end
  end
end
