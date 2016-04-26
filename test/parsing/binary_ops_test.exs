defmodule Plex.BinaryOpTests do
  use ExUnit.Case, async: true
  import Plex.Compiler, only: [parse!: 1]

  test "add op" do
    ast =
      %Plex.Compiler.Node.BinaryOp{
               left: {:identifier, 1, :x},
               right: {:identifier, 1, :y},
               line: 1,
               type: :+
           }

     assert {:ok, [ast]} == parse!("x + y")
  end

  test "subtraction op" do
    ast =
      %Plex.Compiler.Node.BinaryOp{
               left: {:identifier, 1, :x},
               right: {:identifier, 1, :y},
               line: 1,
               type: :-
           }

     assert {:ok, [ast]} == parse!("x - y")
  end

  test "multiplication op" do
    ast =
      %Plex.Compiler.Node.BinaryOp{
               left: {:identifier, 1, :x},
               right: {:identifier, 1, :y},
               line: 1,
               type: :*
           }

     assert {:ok, [ast]} == parse!("x * y")
  end

  test "division op" do
    ast =
      %Plex.Compiler.Node.BinaryOp{
               left: {:identifier, 1, :x},
               right: {:identifier, 1, :y},
               line: 1,
               type: :/
           }


     assert {:ok, [ast]} == parse!("x / y")
  end

  test "binary op precedence" do
    ast =
      %Plex.Compiler.Node.BinaryOp{
               left: {:integer, 1, 1}, line: 1,
               right: %Plex.Compiler.Node.BinaryOp{
                          left: {:integer, 1, 2}, line: 1,
                          right: %Plex.Compiler.Node.BinaryOp{
                                     left: {:integer, 1, 3}, line: 1,
                                     right: {:integer, 1, 4},
                                     type: :-
                                 },
                          type: :*
                      }, type: :+
           }

     assert {:ok, [ast]} == parse!("1 + 2 * 3 - 4")
  end
end
