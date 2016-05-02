defprotocol Plex.Compiler.Node do
  @moduledoc "Protocol for node evaluation"

  alias Plex.Compiler.Node.{
            Let, If, For,
            While, BinaryOp,
            UnaryOp, Apply,
            Case, Function,
            Project,
            List, Tuple,
            Range, Record,
            UpdateRef, Deref
  }

  @type t :: If.t
            | For.t
            | BinaryOp.t
            | UnaryOp.t
            | Apply.t
            | Case.t
            | For.t
            | Function.t
            | Project.t
            | Let.t
            | List.t
            | Tuple.t
            | Range.t
            | Record.t
            | While.t
            | Deref.t
            | UpdateRef.t


  @type env :: map

  @doc "Evaluates the node"
  @spec eval(Plex.Compiler.Node.t, env) :: env
  def eval(node, env)

  #@doc "Formats the node for pretty display"
  #@spec format(Plex.Compiler.Node.t) :: env
  #def format(node)
end
