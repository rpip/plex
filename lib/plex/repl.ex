defmodule Plex.Repl do
  @moduledoc "Starts a repl to evauluate Plex code"
  @usage """
  /help - Print this help message \n
  /quit - Exit the REPL \n
  /lex  - Tokenize code \n
  /pp   - Tokenize and parse code
  """
  require Logger

  def start do
    IO.puts("Plex (0.0.1) - type (q) to exit\n")
    pid = spawn(fn -> repl([]) end)
    io(pid, 1, "plex")
  end

  def repl(env) do
    receive do
      {from, :exit} ->
        :ok
      {from, :help} ->
        IO.puts @usage
        repl(env)
      {from, {:lex, code}} ->
        tokens = Plex.Compiler.lex(code)
        Enum.each(tokens, fn(token) -> IO.puts inspect(token) end)
        repl(env)
      {from, {:pp, code}} ->
        tokens = Plex.Compiler.lex(code)
        {:ok, ast} = Plex.Compiler.parse(tokens)
        Enum.each(ast, fn(node) -> IO.puts inspect(node) end)
        repl(env)
      {from, {:eval, code}} ->
        # TODO: analyze and evaluate ast
        # Plex.Compiler.Parser.eval(ast)
        result = Plex.Compiler.lex(code) |> Plex.Compiler.parse
        IO.puts (inspect result)
        repl(env)
    end
  end

  defp io(repl_id, counter, prefix) do
    case IO.gets(:stdio, "#{prefix} (#{counter})> ") do
      :eof ->
        send(repl_id, :exit)
      {:error, reason} ->
        Plex.Logger.error("Error reading from stdin: #{reason}")
        io(repl_id, counter + 1, prefix)
      text ->
        text = String.strip(text)
        case text do
          <<"/quit", _ :: binary>> ->
            send(repl_id, :exit)
          <<"/help", _ :: binary>> ->
            send(repl_id, {self, :help})
            io(repl_id, counter + 1, prefix)
          <<"/lex", rest :: binary>> ->
            send(repl_id, {self, {:lex, rest}})
            io(repl_id, counter + 1, prefix)
          <<"/pp", rest :: binary>> ->
            send(repl_id, {self, {:pp, rest}})
            io(repl_id, counter + 1, prefix)
          b = <<"/",_ :: binary>> ->
            Logger.error("Unknown command: #{b}")
            io(repl_id, counter + 1, prefix)
          code ->
            send(repl_id, {self, {:eval, code}})
            io(repl_id, counter + 1, prefix)
        end
    end
  end
end
