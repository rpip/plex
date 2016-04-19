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

defmodule Plex.Compiler.Env do
  defstruct [
    local_env: %{},
    enclosing_env: %{},
    builtin_env: %{},
  ]
end

defmodule Plex.Compiler.Scope do
  @moduledoc """
  Manages the scope of the expressions. Internally, the scope is managed by a
  process using Elixir Agent module which holds a dictionary of the bindings.

  This enables parallel executions of expressions since they can both access the
  easily, but this also potential of conflicts from multiple expressions
  mutating the values.
  """

  @type t :: map

  @doc "Creates a new environment"
  @spec new :: Agent.on_start
  def new(default_bindings \\ %{}) do
    Agent.start_link(fn -> default_bindings end, name: __MODULE__)
  end

  @doc "Binds a value to a name in the scope"
  def bind(name, value) do
    Agent.update(__MODULE__, &Map.put(&1, name, value))
  end

  @doc "Binds a list of expressions"
  @spec bind_many(list) :: :ok
  def bind_many(names) do
    Enum.each(names, fn({k, v}) ->  bind(k, v) end)
  end

  @doc "Removes a binding from the environment"
  @spec unbind(atom) :: :ok
  def unbind(name) do
    Agent.update(__MODULE__, &Map.drop(&1, [name]))
  end

  @doc "Searches for a binding by the name given and returns it if found"
  @spec lookup_name(atom) :: any
  def lookup_name(name) do
    Agent.get(__MODULE__, &Map.get(&1, name))
  end

  @doc "Returns all the bindingss"
  def bindings do
    Agent.get(__MODULE__, &(&1))
  end
end
