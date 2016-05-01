defmodule Plex.Repl do
  @moduledoc "Starts a repl to evauluate Plex code"
  @usage """
  /h   - Print this help message
  /q   -  Exit the REPL
  /lex - Tokenize code
  /pp  - Tokenize and parse code
  """
  import Plex.Logger, only: [info: 1, error: 1]
  alias Plex.Env

  def run(env) do

    if tty_works? do
      function = fn() ->
        spawn(fn ->
          :ok = :io.setopts(Process.group_leader(), [binary: true, encoding: :unicode])

          start_repl(env)

          send(Process.whereis(:plex_repl), {self, :tty_sl_exit})

          :ok
        end)
      end

      :user_drv.start([:"tty_sl -c -e", {:erlang, :apply, [function, []]}])

      receive do: (:tty_sl_exit -> :ok)
    else
      start_repl(env)
    end
  end

  def tty_works? do
    try do
      port = Port.open({:spawn, 'tty_sl -c -e'}, [:eof])
      Port.close(port)
    catch _, _ ->
        false
    end
  end

  defp start_repl(env) do
    IO.puts("Plex (0.0.1)")
    IO.puts @usage
    term = System.get_env("TERM") || ""
    IO.puts("Using a #{if tty_works?, do: "smart", else: "dumb"} terminal (TERM = \"#{term}\").")

    pid = spawn(fn -> repl(env) end)
    Process.register(pid, :plex_repl)
    io(pid, 1, "plex")
  end

  defp repl(env, cache \\ "") do
    receive do
      {from, :tty_sl_exit} ->
        send(from, :tty_sl_exit)
      {_from, :exit} ->
        :ok
      {_from, :help} ->
        IO.puts @usage
        repl(env)
      {_from, {:lex, code}} ->
        tokens = Plex.Compiler.lex(code)
        Enum.each(tokens, fn(token) -> info(inspect(token)) end)
        repl(env)
      {_from, {:pp, code}} ->
        result = Plex.Compiler.parse!(code)
        info(inspect(result))
        repl(env)
      {from, {:eval, code}} ->
        # TODO: analyze and evaluate ast
        code = cache <> code
        result = Plex.Compiler.parse!(code)
        case result do
          {:ok, ast} ->
            result = Plex.Compiler.eval(ast, env)
            send(from, {:ok, result})
            repl(env)
          # incomplete input
          {:error, {_, :plex_parse, [_reason,[]]}} ->
            send(from, :do_input)
            repl(env, code <> " ")
          {:error, _} ->
            send(from, {:error, result})
            repl(env)
        end
    end
  end

  defp prompt(counter, prefix) do
    "#{prefix} (#{counter})> "
  end

  defp io(repl_id, counter, prefix) do
    case IO.gets(prompt(counter, prefix)) do
      :eof ->
        send(repl_id, :exit)
      {:error, reason} ->
        error("Error reading from stdin: #{reason}")
        io(repl_id, counter + 1, prefix)
      text ->
        text = String.strip(text)
        case text do
          <<"/q", _ :: binary>> ->
            send(repl_id, :exit)
          <<"/h", _ :: binary>> ->
            send(repl_id, {self, :help})
            io(repl_id, counter + 1, prefix)
          <<"/lex", rest :: binary>> ->
            send(repl_id, {self, {:lex, rest}})
            io(repl_id, counter + 1, prefix)
          <<"/pp", rest :: binary>> ->
            send(repl_id, {self, {:pp, rest}})
            io(repl_id, counter + 1, prefix)
          b = <<"/",_ :: binary>> ->
            error("Unknown command: #{b}")
            io(repl_id, counter + 1, prefix)
          code ->
            code =  String.rstrip(code, ?\n)
            if String.length(code) == 0 do
              io(repl_id, counter + 1, prefix)
            else
              send(repl_id, {self, {:eval, code}})
              receive do
                {:ok, result} ->
                  info(inspect result)
                  io(repl_id, counter + 1, prefix)
                :do_input ->
                  # TODO: change prefix to indicate expecting more input
                  io(repl_id, counter, prefix)
                {:error, result} ->
                 error(inspect result)
                 io(repl_id, counter + 1, prefix)
              end
            end
        end
    end
  end
end
