defmodule Plex.Logger do
  @moduldoc "Utilities for logging"

  def info(str) do
    log(colourize("Info"), str)
  end

  def warn(str) do
    log(colourize("Warning", :yellow), str)
  end

  def debug(str) do
    log(colourize("Debug", :magenta), str)
  end

  def error(str) do
    log(colourize("[error]", :red), str)
  end

  defp log(prefix, str, sep \\ ":") do
    IO.puts("#{prefix} #{sep} #{str}")
  end

  defp colourize(str) do
    IO.ANSI.format_fragment([str])
  end

  defp colourize(str, colour) do
    IO.ANSI.format_fragment([colour, str, :reset])
  end
end
