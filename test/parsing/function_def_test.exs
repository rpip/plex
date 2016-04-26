defmodule Plex.FunctionDefTest do
  use ExUnit.Case, async: true
  import Plex.Compiler, only: [parse!: 1]

  test "lambda expression" do
    ast = (
      %Plex.Compiler.Node.Function{
              body: %Plex.Compiler.Node.BinaryOp{
                        left: {:identifier, 1, :x}, line: 1,
                        right: {:identifier, 1, :y}, type: :+},
              line: 1,
              params: [
                {:identifier, 1, :x},
                {:identifier, 1, :y}
              ]
          }
    )

    assert {:ok, [ast]} == parse!("fn x, y -> x + y")
  end

  test "syntactic function def with one argument" do
    ast = (
      %Plex.Compiler.Node.Let{bindings: [
                                   {
                                       {:identifier, 1, :greet},
                                       %Plex.Compiler.Node.Function{
                                                body: %Plex.Compiler.Node.Apply{
                                                          applicant: {:identifier,1, :print},
                                                          args: [
                                                            {:identifier, 1, :message}
                                                          ], line: 1},
                                                line: 1,
                                                params: [
                                                  {:identifier,1, :message}
                                                ]
                                            }
                                   }
                                 ],
                              in_block: nil, line: 1}
    )

    assert {:ok, [ast]} == parse!("let greet message = print message")
  end

  test "syntactic function def with two arguments" do
    ast = (%Plex.Compiler.Node.Let{
                    bindings: [
                      {{:identifier, 1, :add},
                       %Plex.Compiler.Node.Function{
                                body:
                                %Plex.Compiler.Node.BinaryOp{
                                         left: {:identifier, 1, :x}, line: 1,
                                         right: {:identifier,1, :y}, type: :+}, line: 1,
                                params: [
                                  {:identifier, 1, :x},
                                  {:identifier, 1, :y}
                                ]
                            }
                      }
                    ], in_block: nil, line: 1}

    )
    assert {:ok, [ast]} == parse!("let add x, y = x + y")
  end
end
