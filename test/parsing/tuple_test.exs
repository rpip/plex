defmodule Plex.TupleTest do
  use ExUnit.Case, async: true
  import Plex.Compiler, only: [parse!: 1]

  test "homegenous tuple" do
    ast =
      %Plex.Compiler.Node.Tuple{
               elements: [
                       {:integer, 1, 1},
                       {:integer, 1, 2},
                       {:integer, 1, 3}
                   ],
               line: 1
           }

    assert {:ok, [ast]} == parse!("{1, 2, 3}")
  end

  test "complex tuple types" do
    ast =
      %Plex.Compiler.Node.Tuple{
               elements: [
                       {:integer, 1, 1},
                       {:atom, 1, :foo},
                       %Plex.Compiler.Node.List{
                                elements: [],
                                line: 1
                            },
                       {:identifier, 1, :y},
                       %Plex.Compiler.Node.Apply{
                                applicant:
                                {:identifier, 1, :add},
                                args: [
                                  {:identifier, 1, :num1},
                                  {:identifier, 1, :num2}
                                ],
                                line: 1
                            },
                       %Plex.Compiler.Node.Function{
                                body: %Plex.Compiler.Node.BinaryOp{
                                          left: {:identifier, 1, :n},
                                          line: 1,
                                          right: {:integer, 1, 1},
                                          type: :+
                                      },
                                line: 1,
                                params:
                                [:n]
                            }
                   ],
               line: 1
           }

    assert {:ok, [ast]} == parse!("{1, :foo, [], y, add(num1,num2), fn n -> n + 1}")
  end
end
