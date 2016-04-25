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

  test "single-line comment type" do
    assert {:ok, []} == parse!("-- this is a comment")
  end

  test "multi-line comment type" do
    assert {:ok, []} == parse!("""
                          --[[
                          this is a comment. We can even insert Plex
                          expressions here but they will be ignored!
                          --]]
                        """)
  end
end
