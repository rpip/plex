defmodule Plex do
  alias Plex.{Env, Core, Compiler, Repl}

  defmodule CLI do
    @moduledoc "Plex command line script"

    def main([]) do
      Env.new
      |> Core.bootstrap
      |> Repl.run
    end

    def main([file|_]) do
      path = Path.absname(file)

      File.read!(path)
      |> Compiler.parse!
      |> Compiler.eval(Core.bootstrap(Env.new))
      |> inspect
      |> IO.puts
    end
  end

  defmodule Core do
    alias Plex.Types.Ref

    def namespace do
      %{
              ref: &Ref.new/1,
              not: &Kernel.not/1,
              fst: &(elem(&1, 0)),
              snd: &(elem(&1, 1)),
              nth: &Enum.nth/2,
              fail: &fail/1,
              _argv_: &System.argv/0,
              print: &IO.puts/1,
              read: &IO.gets/1,
              map: &Enum.map/3,
              reduce: &Enum.reduce/3,
            head: fn [h|_] -> h end,
            tail: fn [_|t] -> t end
            #eval: %Closure{value: fn ast, env -> Compiler.eval!(ast, env) end},
          }
    end

    def bootstrap(env) do
      Env.merge(env, namespace)

      env
    end

    def fail(message) do
      raise Plex.Compiler.RuntimeError, message: message
    end

  end
end
