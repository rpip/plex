defmodule Plex.Compiler.Node.App do
  @moduledoc "Function application"

  @type t :: %__MODULE__{
            line: integer,
            applicant: Plex.Compiler.Node.t,
            args: Plex.Compiler.Node.t
        }

  defstruct [
    :line,
    :applicant,
    :args
  ]
end
