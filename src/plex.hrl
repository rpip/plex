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
-record('let', {line, name, value, with_clause, in_clause}).
-record(list, {line, elements = []}).
-record(project, {line, object, field}).
-record(function, {line, args = [], body}).
-record('if', {line, condition, true_clause, false_clause}).
-record(app, {line, applicant, args = []}).
-record(range, {line, first, last}).
-record(block_comment, {line, contents = []}).
-record(reference_get, {line, name}).
-record(reference_update, {line, name, value}).
-record(for, {line, var, container, body}).
-record(while, {line, condition, body}).
-record(interpolate, {line, body}).
-record(list_comprehension, {line, output_expr, def, generator, guard}).
-record('case', {line, expr, clauses}).

%% Functions
unwrap({_Token, _Line, Value}) -> Value.
