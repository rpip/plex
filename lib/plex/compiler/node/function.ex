defmodule Plex.Compiler.Closure do
  defstruct [:value]
end


defmodule Plex.Compiler.Node.Function do
  @moduledoc "Function defs"

  alias __MODULE__
  alias Plex.{Compiler, Env}
  import Plex.Utils, only: [unwrap: 1]

  @type t :: %__MODULE__{
            line: integer,
            params: list,
            body: any
        }

  defstruct [
    :line,
    :params,
    :body
  ]

  defimpl Plex.Compiler.Node do
    def eval(%Function{params: params, body: body}, env) do
      closure = fn args ->
        params = Enum.map(params, &unwrap/1)
        bindings = Enum.zip(params, args) |> Enum.into(%{})
        local_scope = Env.new(env, bindings)
        Compiler.eval(body, local_scope)
      end

      %Plex.Compiler.Closure{value: closure}
    end
  end
end
