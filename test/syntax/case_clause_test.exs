defmodule Plex.CaseClauseTest do
  use ExUnit.Case, async: true
  import Plex.Compiler, only: [parse!: 1]

  test "case clause" do
    ast =
      %Plex.Compiler.Node.Case{
               clauses: [
                 {
                     {:integer, 2, 1},
                     {:atom, 3, :number}
                 },
                 {
                     %Plex.Compiler.Node.Range{
                              from: {:integer, 4, 3},
                              line: 4,
                              to: {:integer, 4, 10}
                          },
                     {:atom, 5, :range}
                 },
                 {
                     %Plex.Compiler.Node.List{
                              elements: [],
                              line: 6
                          },
                     {:atom, 7, :list}
                 },
                 {
                     %Plex.Compiler.Node.Record{
                              line: 8,
                              properties: []
                          },
                     {:atom, 9, :record}
                 }
               ],
               expr: {:identifier, 1, :x},
               line: 1
           }

    code = """
      case x do
          1 ->
              :number;
          3..10 ->
              :range;
          [] ->
              :list;
          {} ->
              :record
      end
    """

    assert {:ok, [ast]} == parse!(code)
  end
end
