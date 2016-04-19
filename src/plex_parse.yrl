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
  for_expr
  while_expr
  range_expr
  case_expr
  clauses
  clause
  pattern
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
  app
  args
  .

Terminals

  '[' ']' '+' '-' '*' '/' '%' ',' '=' ':=' '{' '}' '(' ')' '<' '>' '==' '!='
  '..' 'not' 'let' 'with' 'in' '->' '.' 'fn' 'if' 'then' 'else' '!'
  'and' 'or' 'for' 'do' 'while' 'end' 'case' true false integer float string
   nil identifier eol atom block_comment string_interpolate
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
expr -> string  : '$1'.
expr -> atom  : '$1'.
expr -> number  : '$1'.
expr -> record : '$1'.
expr -> block_comment : '$1'.
expr -> list : '$1'.
expr -> if_expr : '$1'.
expr -> project : '$1'.
expr -> function : '$1'.
expr -> app : '$1'.
expr -> for_expr : '$1'.
expr -> while_expr : '$1'.
expr -> case_expr : '$1'.
expr -> range_expr : '$1'.
expr -> '(' expr ')' : '$2'.
expr -> string_interpolate :
  #interpolate{
     line=?line('$1'),
     body='$1'
    }.
%% references
expr -> '!' identifier :
  #deref{
     line=?line('$1'),
     name='$2'
  }.
expr -> identifier ':=' expr :
  #update_ref{
     line=?line('$1'),
     name='$1',
     value='$3'
  }.

%% range
range_expr -> integer '..' integer :
  #range{
     line=?line('$1'),
     first='$1',
     last='$3'
    }.

%% Let bindings
expr -> 'let' identifier '=' expr  :
  #'let'{
     line=?line('$1'),
     name='$2',
     value='$4'
    }.
expr -> 'let' identifier '=' expr 'with' expr :
  #'let'{
     line=?line('$1'),
     name='$2',
     value='$4',
     with_clause='$6'
  }.
expr -> 'let' identifier '=' expr 'in' expr :
  #'let'{
     line=?line('$1'),
     name='$2',
     value='$4',
     in_clause='$6'
    }.

%% Call expressions
app -> expr '(' ')':
  #app{
    line=?line('$1'),
    applicant='$1'
   }.
app -> expr args :
  #app{
    line=?line('$1'),
    applicant='$1',
    args=['$2']
   }.
app -> expr '(' args ')':
  #app{
    line=?line('$1'),
    applicant='$1',
    args=['$3']
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
elem  -> record : '$1'.
elem  -> value  : '$1'.
elem  -> function : '$1'.
elem  -> app : '$1'.

value -> list : '$1'.
value -> string : '$1'.
value -> number : '$1'.
value -> atom : '$1'.
value -> boolean : '$1'.
value -> identifier : '$1'.

%% Tuples
record -> '{' elems '}'       :
  #tuple{
     line=?line('$1'),
     elements=to_tuple('$2')
    }.

%% Records
record -> '{' '}' : #record{line=?line('$1')}.
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
args -> expr : ['$1'].
args -> expr ',' args : ['$1'|'$3'].

%% FOR expressions
for_expr -> 'for' expr 'in' expr 'do' 'end':
  #for{
     line=?line('$1'),
     var='$2',
     container='$4'
    }.
for_expr -> 'for' expr 'in' expr 'do' expr 'end':
  #for{
     line=?line('$1'),
     var='$2',
     container='$4',
     body='$6'
    }.

%% WHILE expressions
while_expr -> 'while' expr 'do' expr 'end' :
  #while{
     line=?line('$1'),
     condition='$2',
     body='$4'
    }.

%% CASE expressions
case_expr -> 'case' expr 'do' clauses 'end' :
  #'case'{
     line=?line('$1'),
     expr='$2',
     clauses='$4'
    }.

clause -> pattern '->' expr : [{'$1','$3'}].
clauses -> clause : ['$1'].
clauses -> clause eol clauses : ['$1'|'$3'].
clauses -> clause clauses : ['$1'|'$2'].

pattern -> atom       : '$1'.
pattern -> string     : '$1'.
pattern -> list       : '$1'.
pattern -> record     : '$1'.
pattern -> identifier : '$1'.
pattern -> number     : '$1'.
pattern -> range_expr : '$1'.

%% IF conditions
if_expr -> 'if' expr 'then' expr :
  #'if'{
     line=?line('$1'),
     condition='$2',
     true_clause='$4'
    }.
if_expr -> 'if' expr 'then' expr 'else' expr :
  #'if'{
     line=?line('$1'),
     condition='$2',
     true_clause='$4',
     false_clause='$6'
    }.

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

%% Boolean values
boolean -> true  : '$1'.
boolean -> false : '$1'.
boolean -> nil   : '$1'.

%% Numbers
number -> float   : '$1'.
number -> integer : '$1'.

Erlang code.

-include("plex.hrl").
