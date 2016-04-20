defmodule Plex.Compiler.SyntaxError do
  @type t :: %__MODULE__{
            error: binary,
            location: %{file: binary, line: integer}
        }

  defexception [
    :error,
    :location
  ]

  def message(exception) do
    "#{exception.error}. #{exception.location.file}, #{exception.location.line}"
  end
end


defmodule Plex.Compiler.CompileError do
  @type t :: %__MODULE__{
            error: binary,
            location: %{file: binary, line: integer}
        }

  defexception [
    :error,
    :location
  ]

  def message(exception) do
    "#{exception.error}. #{exception.location.file}, #{exception.location.line}"
  end
end


defmodule Plex.CompileError.RuntimeError do
  @moduledoc """
  Runtime error exceptions. These errors will eventually be handled at compile
  by the analyzer.

  # runtime error types
  - NumArgs
  - UnboundVar
  - NotApplicable
  - TypeMisMatch
  """
  @type t :: %__MODULE__{
            error: binary,
            location: %{file: binary, line: integer},
            scope: map,
            meta: map
        }

  defexception [
    :error,
    :location,
    :scope,
    :meta
  ]

  def message(exception) do
    "#{exception.error}. #{exception.location.file}, #{exception.location.line}"
  end
end
