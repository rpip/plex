defmodule Plex.Analyzer do
  @moduledoc """
  Analyzes the code for suggestions on optimizations/improvements.

  ## Main tasks
  - type checking
  - check function arity
  - check identifiers
  - check if function arguments are used in the body. If not, mark arguments
  - CTE, compile time execution
  - warnings on variables
  - check for mutations, prevent rebinding immutable vars
  - expand range values when in the right context
  """
end
