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
-record(bind, {line, name, value, with_clause, in_clause}).
-record(list, {line, elements = []}).
-record(project, {line, object, field}).
-record(function, {line, args = [], body}).
-record('if', {line, cond_clause, true_clause, false_clause}).
-record(call_expr, {line, applicant, args = []}).
-record(range, {line, first, last}).
-record(block_comment, {line, contents = []}).

%% Functions
unwrap({_Token, _Line, Value}) -> Value.
