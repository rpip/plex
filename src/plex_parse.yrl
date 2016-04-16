%%% @author Yao Adzaku <yao@abakhi.com>
%%% @copyright (C) 2016, Yao Adzaku
%%% @doc
%%% Yecc grammar for Plex language
%%% @end
%%% Created : 16 Apr 2016 by Yao Adzaku <yao@abakhi.com>

Nonterminals
  root
  expr_list
  expr
  if_expr
  arith
  record
  field
  fields
  list
  elems
  elem
  value
  boolean
  number
  project
  function
  call_expr
  args
  .

Terminals

  '[' ']' '+' '-' '*' '/' '%' ',' '=' '{' '}' '(' ')' '<' '>' '==' '!='
  'not' 'let' 'with' 'in' '->' '.' 'fn' 'if' 'then' 'else'
  'and' 'or' true false integer float string nil identifier eol
  .

Rootsymbol root.

root -> expr_list : '$1'.
root -> '$empty' : [].

%% Expression lists (eol delimited)
expr_list -> eol : [].
expr_list -> expr : ['$1'].
expr_list -> expr eol : ['$1'].
expr_list -> eol expr_list : '$2'.
expr_list -> expr eol expr_list : ['$1'|'$3'].

expr -> identifier : '$1'.
expr -> arith   : '$1'.
expr -> boolean : '$1'.
expr -> string  : unwrapn('$1').
expr -> number  : '$1'.
expr -> record : '$1'.
expr -> list : '$1'.
expr -> if_expr : '$1'.
expr -> project : '$1'.
expr -> function : '$1'.
expr -> call_expr : '$1'.
expr -> '(' expr ')' : '$2'.
expr -> 'let' identifier '=' expr  :
  #bind{
     line=?line('$1'),
     name='$2',
     value='$4'
    }.

expr -> 'let' identifier '=' expr 'with' expr :
  #bind{
     line=?line('$1'),
     name='$2',
     value='$4',
     with_clause='$6'
  }.
expr -> 'let' identifier '=' expr 'in' expr :
  #bind{
     line=?line('$1'),
     name='$2',
     value='$4',
     in_clause='$6'
    }.

%% Call expressions
call_expr -> expr expr :
  #call_expr{
    line=?line('$1'),
    applicant='$1',
    args=['$2']
   }.
call_expr -> expr expr ',' expr :
  #call_expr{
    line=?line('$1'),
    applicant='$1',
    args=['$2'|'$4']
   }.


%% Lists
list -> '[' ']'        :
  #list{
    line=?line('$1'),
    elements=[]
  }.
list -> '[' elems ']'  :
  #list{
    line=?line('$1'),
    elements='$2'
  }.

elems -> elem       : ['$1'].
elems -> elem ',' elems : ['$1'|'$3'].
elem ->  record : '$1'.
elem ->  value  : '$1'.

value -> list : unwrapn('$1').
value -> string : unwrapn('$1').
value -> number : unwrapn('$1').
value -> boolean : unwrapn('$1').
value -> identifier : unwrapn('$1').

%% Records
record -> '{' '}'              :
  #record{
     line=?line('$1'),
     properties=[]
    }.

record -> '{' fields '}'       :
  #record{
     line=?line('$1'),
     properties='$2'
    }.
field  -> identifier '=' expr  : {'$1', '$3'}.
fields -> field                : ['$1'].
fields -> field ',' fields     :['$1'|'$3'].

project -> identifier '.' identifier :
  #project{
    line=?line('$1'),
    object='$1',
    field='$3'
  }.

%% Functions
function -> 'fn' '->' expr :
  #function{
     line=?line('$1'),
     args=[],
     body='$3'
    }.
function -> 'fn' args '->' expr :
  #function{
     line=?line('$1'),
     args='$2',
     body='$4'
    }.
args -> identifier : ['$1'].
args -> identifier ',' args : ['$1'|'$3'].

if_expr -> 'if' expr 'then' expr :
  #'if'{
     line=?line('$1'),
     cond_clause='$2',
     true_clause='$4'
    }.
if_expr -> 'if' expr 'then' expr 'else' expr :
  #'if'{
     line=?line('$1'),
     cond_clause='$2',
     true_clause='$4',
     false_clause='$6'
    }.

%% Boolean values
boolean -> true  : '$1'.
boolean -> false : '$1'.
boolean -> nil   : '$1'.

%% Numbers
number -> float   : '$1'.
number -> integer : '$1'.

%% Arithmetic and boolean  operations
arith -> expr '+' expr	:
  #binary_op{
    line=?line('$1'),
    type='plus',
    left='$1',
    right='$3'
   }.

arith -> expr '-' expr	:
  #binary_op{
    line=?line('$1'),
    type='sub',
    left='$1',
    right='$3'
  }.

arith -> expr '*' expr	:
  #binary_op{
    line=?line('$1'),
    type='mul',
    left='$1',
    right='$3'
  }.

arith -> expr '/' expr	:
  #binary_op{
    line=?line('$1'),
    type='div',
    left='$1',
    right='$3'
  }.

arith -> expr '%' expr :
   #binary_op{
     line=?line('$1'),
     type='rem',
     left='$1',
     right='$3'
   }.

boolean -> 'not' expr :
  #unary_op{
    line=?line('$1'),
    type=?op('$1'),
    arg='$2'
   }.
boolean -> expr '>' expr   :
 #binary_op{
    line=?line('$1'),
    type='>',
    left='$1',
    right='$3'
   }.
boolean -> expr '<' expr :
  #binary_op{
    line=?line('$1'),
    type='<',
    left='$1',
    right='$3'
  }.
boolean -> expr '==' expr :
  #binary_op{
    line=?line('$1'),
    type='==',
    left='$1',
    right='$3'
  }.
boolean -> expr '!=' expr :
  #binary_op{
     line=?line('$1'),
     type='!=',
     left='$1',
     right='$3'
    }.
boolean -> expr 'and' expr :
  #binary_op{
    line=?line('$1'),
    type='and',
    left='$1',
    right='$3'
  }.
boolean -> expr 'or' expr  :
  #binary_op{
    line=?line('$1'),
    type='or',
    left='$1',
    right='$3'
  }.

Erlang code.

-define(line(Node), element(2, Node)).
-define(op(Node), element(1, Node)).
-define(identifier_name(Id), element(3, Id)).

%% Records
-record(record, {line, properties}).
-record(binary_op, {line, type, left, right}).
-record(unary_op, {line, type, arg}).
-record(bind, {line, name, value, with_clause, in_clause}).
-record(list, {line, elements}).
-record(project, {line, object, field}).
-record(function, {line, args, body}).
-record('if', {line, cond_clause, true_clause, false_clause}).
-record(call_expr, {line, applicant, args}).

%% Functions
unwrapn({_Token, _Line, Value}) -> Value.
