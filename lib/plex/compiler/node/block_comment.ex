defmodule Plex.Compiler.Node.BlockComment do
  @moduledoc """
  Block comments, aka, multi-line comments
  """
  @type t :: %__MODULE__{
            line: integer,
            contents: binary,
        }

  defstruct [
    :line,
    :contents
  ]
end
