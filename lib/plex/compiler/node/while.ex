defmodule Plex.Compiler.Node.While do
  @moduledoc "While loops"

  alias __MODULE__
  alias Plex.Compiler

  @type t :: %__MODULE__{
            line: integer,
            condition: any,
            body: any
        }

  defstruct [
    :line,
    :condition,
    :body
  ]

  defimpl Plex.Compiler.Node do
    def eval(%While{condition: condition, body: body}, env) do
      continue? = Compiler.eval(condition, env)
      do_loop(continue?, condition, body, env)
    end

    defp do_loop(true, condition, body, env) do
      Compiler.eval(body, env)
      continue? = Compiler.eval(condition, env)
      do_loop(continue?, condition, body, env)
    end

    defp do_loop(false, _condition, _body, _env), do: :ok
    defp do_loop(nil, _condition, _body, _env), do: :ok
  end
end
