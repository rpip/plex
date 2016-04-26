defmodule Plex.BasicTypesTest do
  use ExUnit.Case, async: true
  import Plex.Compiler, only: [parse!: 1]

  doctest Plex.Types

  test "integer type" do
    assert {:ok, [{:integer, _, 4}]} = parse!("4")
  end

  test "float type" do
    assert {:ok, [{:float, _, 6.1}]} = parse!("6.1")
  end

  test "single-quoted string type" do
    assert {:ok, [{:string, _, "hello"}]} = parse!("'hello'")
  end

  test "double-quoted string type" do
    assert {:ok, [{:string, _, "hello"}]} = parse!("'hello'")
  end

  test "atom type" do
    assert {:ok, [{:atom, _, :foo}]} = parse!(":foo")
  end

  test "boolean types" do
    assert {:ok, [{:bool, _, true}]} = parse!("true")
    assert {:ok, [{:bool, _, false}]} = parse!("false")
  end

  test "range values" do
    ast =
      %Plex.Compiler.Node.Range{
               from: {:integer, 1, 0},
               line: 1,
               to: {:integer, 1, 10}
           }

    assert {:ok, [ast]} == parse!("0..10")
  end

  test "invalid range" do
    assert {:error, _} = parse!("0..10..12")
  end

  test "single-line comment type" do
    assert {:ok, []} == parse!("-- this is a comment")
  end

  test "multi-line comment type" do
    long_comment =
      """
        --[[
        this is a comment. We can even insert Plex
        expressions here but they will be ignored!
        --]]
      """

    assert {:ok, []} == parse!(long_comment)
  end

  test "list homogenous types" do
    ast =
      %Plex.Compiler.Node.List{
               elements: [
                 {:identifier, 1, :x},
                 {:identifier, 1, :y}
               ],
               line: 1
           }

    assert {:ok, [ast]} == parse!("[x,y]")
  end

  test "complex list" do
    ast =
      %Plex.Compiler.Node.List{
               elements: [
                 {:identifier, 1, :x},
                 {:atom, 1, :foo},
                 %Plex.Compiler.Node.Function{
                          body: %Plex.Compiler.Node.BinaryOp{
                                    left: {:identifier, 1, :x},
                                    line: 1,
                                    right: {:identifier, 1, :y},
                                    type: :+
                                },
                          line: 1,
                          params: [
                            {:identifier, 1, :x},
                            {:identifier, 1, :y}
                          ]
                      },
                 %Plex.Compiler.Node.Apply{
                          applicant: {:identifier, 1, :add},
                          args: [
                            {:integer, 1, 4},
                            {:integer, 1, 4}
                          ],
                          line: 1
                      },
                 %Plex.Compiler.Node.Tuple{
                          elements: {
                                  {:identifier, 1, :bar},
                                  {:identifier, 1, :baz}
                              },
                          line: 1
                      },
                 %Plex.Compiler.Node.Record{
                          line: 1,
                          properties: [
                            {
                                {:identifier, 1, :a},
                                {:identifier, 1, :b}
                            },
                            {
                                {:identifier, 1, :c},
                                {:identifier, 1, :d}
                            }
                          ]
                      }
               ],
               line: 1
           }

    assert {:ok, [ast]} == parse!("[x, :foo, fn x,y -> x + y, add(4,4), {bar, baz}, {a=b,c=d}]")
  end
end
