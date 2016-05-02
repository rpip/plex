defmodule Plex.LetTest do
  use ExUnit.Case, async: true
  import Plex.Compiler, only: [parse!: 1]

  test "let with function attached to binding" do
    ast =
      %Plex.Compiler.Node.Let{
              bindings: [
                {
                    :x,
                    {:integer, 1, 2},
                    {:with_function, %Plex.Compiler.Node.Function{
                                       body: %Plex.Compiler.Node.BinaryOp{
                                                 left: {:identifier, 1, :num},
                                                 line: 1,
                                                 right: {:integer, 1, 10}, type: :+},
                                       line: 1,
                                       params: [:num]
                                   }
                    }
                }
              ],
              in_block: nil,
              line: 1
          }

    assert {:ok, [ast]} == parse!("let x = 2 with fn num ->  num + 10")
  end

  test "complex let with function attached to binding" do
    ast =
      %Plex.Compiler.Node.Let{
               bindings: [
                 {
                     :_,
                     {:record_extension,
                      {
                          {:identifier, 1, :foo},
                          %Plex.Compiler.Node.Record{
                                   line: 1,
                                   properties: [
                                     {
                                         :x,
                                         {:integer, 1, 2}
                                     }
                                   ]
                               }
                      }
                     },
                     {:with_function, %Plex.Compiler.Node.Function{
                                        body: {:identifier, 1, :x},
                                        line: 1,
                                        params: []
                                    }
                     }
                 }
               ], in_block: nil, line: 1}

    assert {:ok, [ast]} == parse!("let _ = (foo with {x=2}) with fn -> x")
   end

  test "let with record expansion" do
    ast =
      %Plex.Compiler.Node.Let{
               bindings: [
                 {
                     :x,
                     %Plex.Compiler.Node.Record{
                              line: 1,
                              properties: [
                                {
                                    :foo,
                                    {:integer, 1, 1}
                                },
                                {
                                    :bar,
                                    {:integer, 1, 3}
                                },
                                {
                                    :baz,
                                    {:record_extension,
                                     {
                                         {:identifier, 1, :person},
                                         %Plex.Compiler.Node.Record{
                                                  line: 1,
                                                  properties: [
                                                    {
                                                        :sex,
                                                        {:atom, 1, :male}
                                                    }
                                                  ]
                                              }
                                     }
                                    }
                                }
                              ]
                          }
                     }
               ],
               in_block: nil,
               line: 1
           }

   assert  {:ok, [ast]} == parse!("let x = {foo=1, bar=3, baz=person with {sex=:male}}")
  end

  test "let with local scope" do
    ast =
      %Plex.Compiler.Node.Let{
               bindings: [
                 {:x, {:integer, 1, 3}}
               ],
               in_block: %Plex.Compiler.Node.BinaryOp{
                             left: {:identifier, 1, :x},
                             line: 1,
                             right: {:integer, 1, 10},
                             type: :+
                         },
               line: 1
           }

    assert {:ok, [ast]} == parse!("let x = 3 in x + 10")
  end


  test "multiple let bindings" do
    ast =
      %Plex.Compiler.Node.Let{
               bindings: [
                 {
                     :x,
                     {:integer, 1, 2}
                 },
                 {
                     :y,
                     {:integer, 1, 4}
                 },
               ],
               in_block: nil,
               line: 1
           }

    assert {:ok, [ast]} == parse!("let x = 2, y = 4")
  end

  test "multiple let bindings in local scope" do
    ast =
      %Plex.Compiler.Node.Let{
               bindings: [
                 {
                     :x,
                     {:integer, 1, 2}
                 },
                 {
                     :y,
                     {:integer, 1, 4}
                 },
               ],
               in_block: %Plex.Compiler.Node.BinaryOp{
                             left: {:identifier, 1, :x},
                             line: 1,
                             right: {:identifier, 1, :y},
                             type: :+
                         },
               line: 1
           }


    assert {:ok, [ast]} == parse!("let x = 2, y = 4 in x + y")
  end

  test "complex multiple let bindings" do
    ast =
      %Plex.Compiler.Node.Let{
               bindings: [
                 {
                     :x,
                     {:integer, 1, 2}
                 },
                 {
                     :y,
                     {:record_extension,
                      {
                          {:identifier, 1, :dog},
                          %Plex.Compiler.Node.Record{
                                   line: 1,
                                   properties: [
                                     { :name, {:string, 1, "Scooby"} }
                                   ]
                               }
                      }
                     }
                 }
               ],
               in_block: nil,
               line: 1
           }

    assert {:ok, [ast]} == parse!("let x = 2, y = dog with {name=\"Scooby\"}")
  end
end
