defmodule Plex do
  alias Plex.{Env, Core}

  defmodule CLI do
    @moduledoc "Plex command line script"

    def main([]) do
      Env.new
      |> Core.bootstrap
      |> Plex.Repl.run
    end

    def main([file|_]) do
      path = Path.absname(file)

      File.read!(path)
      |> Plex.Compiler.parse!
      |> Plex.Compiler.eval(Core.bootstrap(Env.new))
      |> inspect
      |> IO.puts
    end
  end

  defmodule Core do
    alias Plex.Types.Ref

    def namespace do
      %{ref: &Ref.new/1}
    end

    def bootstrap(env) do
      Env.merge(env, namespace)

      env
    end
  end
end
