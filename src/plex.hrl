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
%% Hack for boolean values true and false
unwrap({Value, _Line}) -> Value;

unwrap({_Token, _Line, Value}) -> Value.

to_tuple(Xs) -> erlang:list_to_tuple(Xs).

build_ast_node(Type, Node) ->
  'Elixir.Kernel':struct(list_to_atom("Elixir.Plex.Compiler.Node." ++ atom_to_list(Type)), Node).

extract_line({_, Line,_} = _Node) ->
    Line;
extract_line({_, Line} = _Node) ->
    Line;
extract_line(Node) when is_map(Node) ->
    maps:get(line, Node);
extract_line(Node) ->
  io:format("LINE: ~p ~n", [Node]),
  nil.

sugar_function_def(Identifier, Params, FunctionBody) ->
    sugar_function_def(Identifier, Params, FunctionBody, nil).
sugar_function_def(Identifier, Params, FunctionBody, InBlock) ->
  Function = build_ast_node('Function', #{
     line => ?line(Identifier),
     params => Params,
     body => FunctionBody
    }),
  build_ast_node('Let', #{
     line => ?line(Identifier),
     bindings => [{Identifier, Function}],
     in_block => InBlock
    }).
