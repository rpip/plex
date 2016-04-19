defmodule Plex.Compiler.Node.App do
  @moduledoc "Function application"

  @type t :: %__MODULE__{
            line: integer,
            applicant: any,
            args: list
        }

  defstruct [
    :line,
    :applicant,
    :args
  ]
end
