defmodule Plex.Error do
  @module """
  Raised during evaluation or when syntax error is detected in the input file or
  string.

  # Error types
  - NumArgs
  - UnboundVar
  - NotApplicable
  - TypeMisMatch
  - MatchError
  - SyntaxError
  """
  @type  t :: %__MODULE__{
             type: atom,
             message: String.t,
             file: :nofile | String.t,
             line: integer
         }

  defexception [
    :type,
    :message,
    :file,
    :line,
  ]

  def exception(opts) do
    message = Keyword.fetch!(opts, :message)
    file = Keyword.get(opts, :file, :nofile)
    line = Keyword.get(opts, :line, nil)
    type = Keyword.fetch!(opts, :type)
    full_message =
      case file do
        :nofile ->
          message
        _ ->
          type = Module.split(type) |> Enum.at(-1)
          "#{type} in #{file}:#{line} : #{message}"
      end
    %__MODULE__{line: line, file: file, message: full_message, type: type}
  end

  def syntax_error!(opts) do
    do_raise(SyntaxError, opts)
  end

  def unbound_var!(opts) do
    do_raise(UnboundVar, opts)
  end

  def num_args!(opts) do
    do_raise(NumArgs, opts)
  end

  def not_applicable!(opts) do
    do_raise(NotApplicable, opts)
  end

  def type_mismatch!(opts) do
    do_raise(TypeMisMatch, opts)
  end

  def match_error!(opts) do
    do_raise(MatchError, opts)
  end

  defp do_raise(type, opts) do
    opts = Keyword.merge([type: type], opts)
    raise __MODULE__, opts
  end
end
