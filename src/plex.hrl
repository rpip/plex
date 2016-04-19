%%% @author Yao Adzaku <yao@abakhi.com>
%%% @copyright (C) 2016, Yao Adzaku
%%% @doc
%%% Plex header file
%%% @end
%%% Created : 17 Apr 2016 by Yao Adzaku <yao@abakhi.com>

-define(line(Node), element(2, Node)).
-define(op(Node), element(1, Node)).
-define(identifier_name(Id), element(3, Id)).

%% Records
-record(record, {line, properties = []}).
-record(binary_op, {line :: integer, type :: atom, left :: term, right :: term}).
-record(unary_op, {line, type, arg}).
-record('let', {line, name, value, with_block, in_block}).
-record(list, {line, elements = []}).
-record(project, {line, object, field}).
-record(function, {line, args = [], body}).
-record('if', {line, condition, then_block, else_block}).
-record(app, {line, applicant, args = []}).
-record(range, {line, first, last}).
-record(block_comment, {line, contents = []}).
-record(deref, {line, name}).
-record(update_ref, {line, name, value}).
-record(for, {line, var, container, body}).
-record(while, {line, condition, body}).
-record(interpolate, {line, body}).
-record(list_comprehension, {line, output_expr, def, generator, guard}).
-record('case', {line, expr, clauses}).
-record(tuple, {line, elements}).

%% Functions
unwrap({_Token, _Line, Value}) -> Value.

to_tuple(Xs) -> erlang:list_to_tuple(Xs).
