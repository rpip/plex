defmodule Plex.Compiler.Node.For do
  @moduledoc "For loops"

  alias __MODULE__
  alias Plex.{Compiler, Env}

  @type t :: %__MODULE__{
            line: integer,
            term: atom,
            generator: any,
            body: any
        }

  defstruct [
    :line,
    :term,
    :generator,
    :body
  ]

  defimpl Plex.Compiler.Node do
    def eval(%For{term: term, generator: generator, body: body}, env) do
      local_scope = Env.new(env)
      xs = Compiler.eval(generator, local_scope)
      xs = if Range.range?(xs), do: Enum.to_list(xs), else: xs

      do_loop(term, xs, body, local_scope)
    end

    defp do_loop(term, [], body, env) do
    end

    defp do_loop(term, [h|t], body, env) do
      Env.bind(env, term, h)
      Compiler.eval(body, env)

      do_loop(term, t, body, env)
    end
  end
end
