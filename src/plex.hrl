%%% @author Yao Adzaku <yao@abakhi.com>
%%% @copyright (C) 2016, Yao Adzaku
%%% @doc
%%% Plex header file
%%% @end
%%% Created : 17 Apr 2016 by Yao Adzaku <yao@abakhi.com>

-define(line(Node), extract_line(Node)).
-define(op(Node), element(1, Node)).
-define(identifier_name(Id), element(3, Id)).

%% Functions
unwrap({_Token, _Line, Value}) -> Value.

to_tuple(Xs) -> erlang:list_to_tuple(Xs).

build_ast_node(Type, Node) ->
  'Elixir.Kernel':struct(list_to_atom("Elixir.Plex.Compiler.Node." ++ atom_to_list(Type)), Node).

extract_line({_, Line,_} = Node) ->
    Line;
extract_line({_, Line} = Node) ->
    Line;
extract_line(Node) when is_map(Node) ->
    maps:get(line, Node);
extract_line(Node) ->
  io:format("LINE: ~p ~n", [Node]),
  nil.
