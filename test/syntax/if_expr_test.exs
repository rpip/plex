defmodule Plex.IfElseTest do
  use ExUnit.Case, async: true
  import Plex.Compiler, only: [parse!: 1]

  test "if else" do
    ast =
      %Plex.Compiler.Node.If{
               condition: %Plex.Compiler.Node.BinaryOp{
                              left: {:identifier, 1, :x},
                              line: 1,
                              right: {:identifier, 1, :y},
                              type: :>},
               else_block: {:identifier, 1, :y},
               line: 1,
               then_block: {:identifier, 1, :x}
           }

    assert {:ok, [ast]} == parse!("if x > y then x else y")
  end

end
