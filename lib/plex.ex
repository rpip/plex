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
              nth: &Enum.at/2,
              fail: &fail!/1,
              _argv_: &System.argv/0,
              print: &IO.puts/1,
              read: &IO.gets/1,
            head: fn [h|_] -> h end,
            tail: fn [_|t] -> t end
          }
    end

    def bootstrap(env) do
      Env.merge(env, namespace)

      Env.bind(env, :eval, fn code ->
        local_scope = Env.new(env)
        Compiler.eval!(code, local_scope)
      end)

      Env.bind(env, :map, fn seq, fun ->
        Enum.map(seq, fn elem ->
          fun.value.([elem])
        end)
      end)

      Env.bind(env, :reduce, fn seq, acc, fun ->
        Enum.reduce(seq, acc, fn elem, acc ->
          fun.value.([elem, acc])
        end)
      end)

      # now return the env
      env
    end

    def fail!(message) do
      raise Compiler.RuntimeError, message: message
    end

    def reduce(xs, fun) do
    end
  end
end
