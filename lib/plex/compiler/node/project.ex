defmodule Plex.Compiler.Node.Project do
  @moduledoc "Project of object attribute, for example: `person.name`"

  @type t :: %__MODULE__{
            line: integer,
            object: any,
            field: any
        }

  defstruct [
    :line,
    :object,
    :field
  ]
end
