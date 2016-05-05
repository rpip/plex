defmodule Plex.CaseClauseTest do
  use ExUnit.Case, async: true
  import Plex.Compiler, only: [parse!: 1]

  test "case clause" do
    ast =
      %Plex.Compiler.Node.Let{
                bindings: [
                  x: {:integer, 1, 2},
                  y: %Plex.Compiler.Node.BinaryOp{
                         left: {:identifier, 2, :x},
                         line: 2,
                         right: {:integer, 2, 1}, type: :+}],
                in_block: %Plex.Compiler.Node.Case{
                              clauses: [
                                %Plex.Compiler.Node.Clause{
                                         exprs: [
                                           {:atom, 6, :range}
                                         ],
                                         line: nil,
                                         patterns: [
                                           %Plex.Compiler.Node.Range{
                                                    from: {:integer, 5, 3},
                                                    line: 5,
                                                    to: {:integer, 5, 10}
                                                }
                                         ]
                                     },
                                %Plex.Compiler.Node.Clause{
                                         exprs: [
                                           {:atom, 8, :list}
                                         ],
                                         line: nil,
                                         patterns: [
                                           %Plex.Compiler.Node.List{
                                                    elements: [],
                                                    line: 7
                                                }
                                         ]
                                     },
                                %Plex.Compiler.Node.Clause{
                                         exprs: [
                                           {:atom, 10, :record}
                                         ],
                                         line: nil,
                                         patterns: [
                                           %Plex.Compiler.Node.Record{
                                                    line: 9,
                                                    properties: []
                                                }
                                         ]
                                     },
                                %Plex.Compiler.Node.Clause{
                                         exprs: [
                                           {:atom, 13, :pass}
                                         ],
                                         line: nil,
                                         patterns: [
                                           {:identifier, 11, :y}
                                         ]
                                     },
                                %Plex.Compiler.Node.Clause{
                                         exprs: [
                                           {:atom, 15, :number},
                                           %Plex.Compiler.Node.BinaryOp{
                                                    left: {:integer, 16, 1},
                                                    line: 16,
                                                    right: {:integer, 16, 2},
                                                    type: :+}
                                         ],
                                         line: nil,
                                         patterns: [
                                           {:integer, 14, 1},
                                           {:integer, 14, 2},
                                           {:integer, 14, 4}
                                         ]
                                     },
                                %Plex.Compiler.Node.Clause{
                                         exprs: [
                                           {:atom, 18, :unknown}
                                         ],
                                         line: nil,
                                         patterns: [
                                           {:identifier, 17, :_}
                                         ]
                                     }
                              ],
                              expr: {:identifier, 4, :x},
                              line: 4},
                line: 1
           }

    code = """
    let x = 2,
        y = x + 1
    in
      case x do
          3..10 ->
              :range
          [] ->
              :list
          {} ->
             :record
          y ->
            -- match value of y with x
            :pass
          1, 2, 4 ->
            :number;
            1 + 2
          _ ->
            :unknown
      end;

    """

    assert {:ok, [ast]} == parse!(code)
  end
end
