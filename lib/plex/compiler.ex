defmodule Plex.Compiler do
  @moduledoc """
    Parses text and transaltes into Elixir data structures
  """
  def lex(text) do
    {:ok, tokens, _} = text |> to_char_list |> :plex_scan.string
    tokens
  end

  def parse(tokens) do
    :plex_parse.parse(tokens)
  end

  def parse!(text) do
    tokens = lex(text)

    case tokens do
      [] -> {:ok, []}
      _  -> parse(tokens)
    end
  end
end

defmodule Plex.Types.Ref do
  @moduledoc "Mutable variable"

  alias __MODULE__

  @type t :: %Ref{contents: any}

  defstruct [:contents]

  @spec new(any) :: pid
  def new(value) do
    Agent.start_link(fn -> %Ref{contents: value} end)
  end

  @spec deref(pid) :: Ref.t
  def deref(pid) do
    Agent.get(pid, fn ref -> ref end)
  end

  @spec update(pid, any) :: Ref.t
  def update(pid, new_val) do
    Agent.update(pid, fn ref -> %{ref | contents: new_val} end)
  end
end


defmodule Plex.Compiler.Env do
  @moduledoc "Key-Value bindings managed by a process"

  @type t :: %{outer: __MODULE__.t, env: map}
  @type key :: atom

  @doc "Creates a new environment and returns the pid of the `Agent`"
  @spec new(Env.t | nil, list) :: pid
  def new(outer \\ nil, binds \\ []) do
    {:ok, pid} = Agent.start_link(fn ->
      %{outer: outer, env: %{}}
    end)
    bind_many(pid, binds)
    pid
  end

  @doc "Binds key to value"
  @spec bind(pid, key, any) :: :ok
  def bind(pid, key, value) do
    Agent.update(pid, fn map ->
      %{map | :env => Map.put(map.env, key, value)}
    end)
  end

  @doc "Does multtiple bindings"
  @spec bind_many(pid, [{key, any}] | map) :: :ok
  def bind_many(pid, binds) do
    Enum.each(binds, fn {k, v} -> bind(pid, k, v) end)
  end

  @doc "Removes the binding from the environment"
  @spec unbind(pid, atom) :: :ok
  def unbind(pid, key) do
    Agent.update(pid, fn map ->
      %{map | :env => Map.drop(map.env, [key])}
    end)
  end

  @doc "Merges the second environment into the first one"
  @spec merge(pid, map) :: :ok
  def merge(pid, other_env) do
    Agent.update(pid, fn map ->
      %{map | :env => Map.merge(map.env, other_env)}
    end)
  end

  @doc "Returns the contents of the enviroment"
  @spec bindings(pid) :: map
  def bindings(pid) do
    Agent.get(pid, fn map -> map.env end)
  end

  @doc "Returns value of key, otherwise raises an excepption"
  @spec get!(pid, key) :: value :: no_return
  def get!(pid, key) do
    case find(pid, key) do
      nil -> raise(Plex.Compiler.RuntimeError, error: "unbound variable #{key}")
      env -> lookup_name(env, key)
    end
  end

  def find(pid, key) do
    Agent.get(pid, fn map ->
      case Map.has_key?(map.env, key) do
        true -> pid
        false -> map.outer && find(map.outer, key)
      end
    end)
  end

  defp lookup_name(pid, key) do
    Agent.get(pid, fn map ->
      case Map.fetch(map.env, key) do
        {:ok, value} -> value
        :error -> :not_found
      end
    end)
  end
end
