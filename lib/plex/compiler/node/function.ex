defmodule Plex.Compiler.Closure do

  @type t :: %__MODULE__{
            value: fun,
            arity: integer
        }

  defstruct [
    :value,
    :arity
  ]
end


defmodule Plex.Compiler.Node.Function do
  @moduledoc "Function defs"

  alias __MODULE__
  alias Plex.{Compiler, Env}

  @type t :: %__MODULE__{
            line: integer,
            params: list,
            body: any,
        }

  defstruct [
    :line,
    :params,
    :body,
  ]

  defimpl Plex.Compiler.Node do
    def eval(%Function{params: params, body: body}, env) do
      closure = fn
        # HACK passes {args, %{self: current projected object}}
        {args, extra_env} ->
          bindings =
            Enum.zip(params, args)
            |> Enum.into(%{})
            |> Map.merge(extra_env)

          local_scope = Env.new(env, bindings)
          Compiler.eval(body, local_scope)
        args ->
          bindings = Enum.zip(params, args) |> Enum.into(%{})
          local_scope = Env.new(env, bindings)
          Compiler.eval(body, local_scope)
      end

      %Plex.Compiler.Closure{value: closure, arity: length(params)}
    end
  end
end
