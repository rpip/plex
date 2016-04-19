defmodule Plex.Compiler.SyntaxError do
  @moduledoc "Exception raise for when lexing or parsing fails"

  @type t :: %__MODULE__{
            error: binary,
            location: %{file: binary, line: integer}
        }

  defexception [
    :error,
    :location
  ]

  def message(self) do
   "#{self.error}. #{self.location.file}, #{self.location.line}"
  end
end


defmodule Plex.Compiler.RuntimeError do
  @moduledoc "Exception raised for type checker errors, unbound values et"

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

  def message(self) do
    """
    #{self.error}. #{self.location.file}, #{self.location.line}
    Scope: #{inspect self.scope}
    Meta: #{inspect self.meta}
    """
  end
end
