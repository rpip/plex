defmodule Plex.Compiler do
  @moduledoc """
  Parses text and transaltes into Elixir data structures
  """
  alias __MODULE__
  alias Plex.{Env, Compiler.Node.ValueFunc}

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

  @doc """
  Runtime code evaluation.

  This runs the code through lexing, generates parse tree and evaluates the AST

  ## Example
  iex> import Plex.Compiler, only: [eval!: 2]
  iex> eval!("let x = ref 6 in !x + 10")
  16
  """
  @spec eval!(String.t, Env.t) :: term
  def eval!(code, env) do
    with {:ok, ast} <- parse!(code) do
      eval(ast, env)
    end
  end

  @doc "Evaluates parse tree"
  @spec eval([Compiler.Node.t], Env.t) :: term
  def eval(ast, env) when is_list(ast) do
    Enum.map(ast, &(eval(&1, env)))
    |> Enum.at(-1)
  end

  def eval({:integer, _, n}, _env) do
    n
  end

  def eval({:atom, _, val}, _env) do
    val
  end

  def eval({:string, _, str}, _env) do
    str
  end

  def eval({:identifier, _, name},env) do
    case Env.get!(env, name) do
      %ValueFunc{value: value} -> value
      val -> val
    end
  end

  def eval({:bool, _, val}, _env) do
    val
  end

  def eval({:record_extension, {parent, changeset}}, env) do
    parent = Compiler.eval(parent, env)
    changeset = Compiler.eval(changeset, env)

    Map.merge(parent, changeset)
  end

  def eval(ast, env) do
    Compiler.Node.eval(ast, env)
  end
end
