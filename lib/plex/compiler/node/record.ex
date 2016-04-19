defmodule Plex.Compiler.Node.Record do
  @moduledoc "Record data structures"

  @type t :: %__MODULE__{line: integer, properties: list}

  defstruct [
    :line,
    :properties
  ]
end
