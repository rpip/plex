defmodule Plex.ImperativeTests do
  use ExUnit.Case, async: true
  import Plex.Compiler, only: [parse!: 1]

  test "ref create syntax" do
    ast =
      %Plex.Compiler.Node.Let{
               bindings: [
                 {
                     :tasks,
                     %Plex.Compiler.Node.Apply{
                              applicant: {:identifier, 1, :ref},
                              args: [
                                %Plex.Compiler.Node.List{
                                         elements: [],
                                         line: 1
                                     }
                              ],
                              line: 1
                          }
                 }
               ],
               in_block: nil,
               line: 1
           }

    assert {:ok, [ast]} == parse!("let tasks = ref []")
  end

  test "for loop" do
    ast =
      %Plex.Compiler.Node.For{body:
                              %Plex.Compiler.Node.UpdateRef{
                                       line: 2,
                                       ref: :tasks,
                                       value: %Plex.Compiler.Node.Apply{
                                                  applicant:
                                                  %Plex.Compiler.Node.Project{
                                                           field: :append,
                                                           line: 2,
                                                           object: {:identifier, 2,:list}
                                                       },
                                                  args: [
                                                    {:identifier, 2, :foo},
                                                    {:identifier, 2, :x}
                                                  ],
                                                  line: 2
                                              }
                                   },
                              generator: %Plex.Compiler.Node.Range{from:
                                                                   {:integer, 1, 0},
                                                                   line: 1,
                                                                   to: {:integer, 1, 5}
                                                                  },
                              line: 1,
                              term: :x
                             }

    code = """
      for x in 0..5 do
        tasks := list.append(foo,x)
      end
    """

    assert {:ok, [ast]} == parse!(code)
  end


  test "complex deref" do
    ast =
      [
          %Plex.Compiler.Node.Let{
                   bindings: [
                     x:
                     %Plex.Compiler.Node.Apply{
                              applicant: {:identifier, 1, :ref},
                              args: [
                                {:integer, 1, 3}
                              ],
                              line: 1
                          }
                   ],
                   in_block: %Plex.Compiler.Node.Let{
                                 bindings: [
                                   y:
                                   %Plex.Compiler.Node.Deref{
                                            line: 2,
                                            ref: :x
                                        }
                                 ],
                                 in_block: %Plex.Compiler.Node.UpdateRef{
                                               line: 3,
                                               ref: :x,
                                               value: %Plex.Compiler.Node.BinaryOp{
                                                          left:
                                                          %Plex.Compiler.Node.Deref{
                                                                   line: 3,
                                                                   ref: :x
                                                               },
                                                          line: 3,
                                                          right: {:integer, 3, 1},
                                                          type: :+}
                                           },
                                 line: 2},
                   line: 1
               },
          %Plex.Compiler.Node.BinaryOp{
                   left: {:identifier, 4, :y},
                   line: 4,
                   right: %Plex.Compiler.Node.Deref{
                              line: 4,
                              ref: :x
                          },
                   type: :+
               }
      ]

    code = """
      let x = ref 3 in
        let y = !x in
            (x := !x + 1);
            y + !x
    """

    assert {:ok, ast} == parse!(code)
  end

  test "while loop" do
    ast =
      %Plex.Compiler.Node.While{
               body: %Plex.Compiler.Node.Apply{
                         applicant: {:identifier, 2, :print},
                         args: [
                           {:string, 2, "Task list not empty"}
                         ],
                         line: 2
                     },
               condition: %Plex.Compiler.Node.BinaryOp{
                              left: %Plex.Compiler.Node.Deref{
                                        line: 1,
                                        ref: :tasks
                                    },
                              line: 1,
                              right: %Plex.Compiler.Node.List{
                                         elements: [],
                                         line: 1
                                     },
                              type: :!=
                          },
               line: 1
           }

    code = """
         while !tasks != [] do
           print 'Task list not empty'
         end
      """

    assert {:ok, [ast]} == parse!(code)
  end
end
