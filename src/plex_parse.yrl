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
  range
  let_expr
  case_expr
  clauses
  clause
  pattern
  arith
  record
  record_extension
  bindings
  binding
  list
  elems
  elem
  boolean
  number
  project
  function
  params
  comp_op
  bool_op
  mult_op
  add_op
  ref_update
  deref
  dereferable
  applicable
  .

Terminals

  '[' ']' '+' '-' '*' '/' '%' ',' '=' ':=' '{' '}' '(' ')' '<' '>' '==' '!='
  '..' 'let' 'with' 'in' '->' '.' '^' 'fn' 'if' 'then' 'else' '!' '<=' '>='
  'and' 'or' 'for' 'do' 'while' 'end' 'case' true false integer float string
  nil identifier eol atom string_interpolate
  .

Rootsymbol root.

Right    20  '->'.
Left     30  ','.
Right    90  ':=' '='.
Left     100 'or'.
Left     110 'and'.
Left     140 'in'.
Left     160 'with'.
%% (1 + 2 * 3 -4) :: sub -> plus -> mul
Left     210 '+' '-'.
Left     220 '*' '/'.
Left     300 '.'.
Nonassoc 310 '!' '^'.
Nonassoc 320 '==' '!=' '>=' '<=' '>' '<' '..'.


root -> expr_list : '$1'.

expr_list -> eol : [].
expr_list -> expr : ['$1'].
expr_list -> expr eol : ['$1'].
expr_list -> eol expr_list : ['$2'].
expr_list -> expr eol expr_list : ['$1'|'$3'].

expr -> arith   : '$1'.
expr -> boolean : '$1'.
expr -> string  : '$1'.
expr -> atom  : '$1'.
expr -> number  : '$1'.
expr -> record : '$1'.
expr -> record_extension : '$1'.
expr -> list : '$1'.
expr -> if_expr : '$1'.
expr -> let_expr : '$1'.

expr -> applicable: '$1'.
applicable -> project : '$1'.
applicable -> identifier : '$1'.
applicable -> function : '$1'.
applicable -> '(' applicable ')': '$2'.
%applicable -> '(' applicable expr')': '$2'.

expr -> for_expr : '$1'.
expr -> while_expr : '$1'.
expr -> case_expr : '$1'.
expr -> range : '$1'.
expr -> '(' expr ')' : '$2'.
expr -> ref_update : '$1'.
expr -> deref : '$1'.
expr -> string_interpolate :
  build_ast_node('Apply', #{
     line => ?line('$1'),
     applicant => {identifier, ?line('$1'), eval},
     args => [{string, ?line('$1'), unwrap('$1')}]
    }).
%% Let bindings
let_expr -> 'let' bindings :
  build_ast_node('Let', #{
     line => ?line('$1'),
     bindings => '$2'
    }).
let_expr -> 'let' bindings 'in' expr :
  build_ast_node('Let', #{
     line     => ?line('$1'),
     bindings => '$2',
     in_block => '$4'
    }).
%% Syntactic sugar for function definitions
%% let add x, y = x + y is the rewritten as let add = fn x, y -> x + y
let_expr -> 'let' identifier params '=' expr:
  sugar_function_def('$2', '$3', '$5').
let_expr -> 'let' identifier '(' elems ')' '=' expr:
  sugar_function_def('$2', '$4', '$7').
let_expr -> 'let' identifier params '=' expr 'in' expr:
  sugar_function_def('$2', '$3', '$5', '$7').
let_expr -> 'let' identifier '(' elems ')' '=' expr 'in' expr:
  sugar_function_def('$2', '$4', '$7', '$9').

%% references
deref -> '!' dereferable :
  build_ast_node('Deref', #{
     line => ?line('$1'),
     ref => unwrap('$2')
  }).
ref_update -> dereferable ':=' expr :
  build_ast_node('UpdateRef', #{
     line  => ?line('$1'),
     ref  => unwrap('$1'),
     value => '$3'
  }).
dereferable -> identifier : '$1'.
dereferable -> project : '$1'.

%% Applications
expr -> applicable '(' ')':
  build_ast_node('Apply', #{
    line => ?line('$1'),
    applicant => '$1',
    args => []
   }).
expr -> applicable elems :
  build_ast_node('Apply', #{
    line => ?line('$1'),
    applicant => '$1',
    args => '$2'
   }).
expr -> applicable '(' elems ')':
  build_ast_node('Apply', #{
    line => ?line('$1'),
    applicant => '$1',
    args => '$3'
   }).

%% range
range -> integer '..' integer :
  build_ast_node('Range', #{
     line  => ?line('$1'),
     from =>'$1',
     to  => '$3'
    }).

%% Lists
list -> '[' ']'        :
  build_ast_node('List', #{
    line => ?line('$1'),
    elements => []
  }).
list -> '[' elems ']'  :
  build_ast_node('List', #{
    line => ?line('$1'),
    elements => '$2'
  }).

elems -> elem       : ['$1'].
elems -> elem ',' elems : ['$1'|'$3'].
elem  -> expr : '$1'.

%% Tuples
record -> '{' elems '}'       :
  build_ast_node('Tuple', #{
     line => ?line('$1'),
     elements => '$2'
    }).

%% Records
record -> '{' '}' :
  build_ast_node('Record', #{
    line => ?line('$1'),
    properties => []
  }).
record -> '{' bindings '}' :
  build_ast_node('Record', #{
     line => ?line('$1'),
     properties => '$2'
    }).
binding  -> identifier '=' expr  : {unwrap('$1'), '$3'}.
binding  -> identifier '=' expr 'with' function : {unwrap('$1'), '$3', {with_function, '$5'}}.
bindings -> binding  : ['$1'].
bindings -> binding ',' bindings : ['$1'|'$3'].

record_extension -> expr 'with' record : {record_extension, {'$1', '$3'}}.

project -> identifier '.' identifier :
  build_ast_node('Project', #{
    line   => ?line('$1'),
    object => '$1',
    field  => '$3'
  }).
project -> project '.' identifier:
  build_ast_node('Project', #{
    line   => ?line('$1'),
    object => '$1',
    field  => '$3'
  }).

%% Functions
function -> 'fn' '->' expr :
  build_ast_node('Function', #{
     line => ?line('$1'),
     params => [],
     body => '$3'
    }).
function -> 'fn' params '->' expr :
  build_ast_node('Function', #{
     line => ?line('$1'),
     params => '$2',
     body => '$4'
    }).
params -> identifier : [unwrap('$1')].
params -> params ',' params : '$1' ++ '$3'.

%% FOR expressions
for_expr -> 'for' expr 'in' expr 'do' expr 'end':
  build_ast_node('For', #{
     line => ?line('$1'),
     term => '$2',
     generator => '$4',
     body => '$6'
    }).

%% WHILE expressions
while_expr -> 'while' expr 'do' expr 'end' :
  build_ast_node('While', #{
     line => ?line('$1'),
     condition => '$2',
     body => '$4'
    }).

%% CASE expressions
case_expr -> 'case' expr 'do' clauses 'end' :
  build_ast_node('Case', #{
     line => ?line('$1'),
     expr => '$2',
     clauses => '$4'
    }).

clause -> pattern '->' expr : {'$1','$3'}.
clauses -> clause : ['$1'].
clauses -> clause eol clauses : ['$1'|'$3'].
clauses -> clause clauses : ['$1'|'$2'].

%% Only pattern match on the following
pattern -> atom       : '$1'.
pattern -> string     : '$1'.
pattern -> list       : '$1'.
pattern -> record     : '$1'.
pattern -> identifier : '$1'.
pattern -> number     : '$1'.
pattern -> range : '$1'.


%% IF conditions
if_expr -> 'if' expr 'then' expr :
  build_ast_node('If', #{
     line => ?line('$1'),
     condition => '$2',
     then_block => '$4'
    }).
if_expr -> 'if' expr 'then' expr 'else' expr :
  build_ast_node('If', #{
     line => ?line('$1'),
     condition => '$2',
     then_block => '$4',
     else_block => '$6'
    }).

%% Arithmetic and boolean  operations
arith -> expr add_op expr :
  build_ast_node('BinaryOp', #{
    line  => ?line('$1'),
    type  => ?op('$2'),
    left  => '$1',
    right => '$3'
   }).
arith -> expr mult_op expr :
   build_ast_node('BinaryOp', #{
     line => ?line('$1'),
     type => ?op('$2'),
     left => '$1',
     right => '$3'
   }).
boolean -> expr comp_op expr :
 build_ast_node('BinaryOp', #{
    line => ?line('$1'),
    type => ?op('$2'),
    left => '$1',
    right => '$3'
   }).
boolean -> expr bool_op expr :
  build_ast_node('BinaryOp', #{
    line  => ?line('$1'),
    type  => ?op('$2'),
    left  => '$1',
    right => '$3'
  }).

%% Boolean values
boolean -> true  : {bool, ?line('$1'), unwrap('$1')}.
boolean -> false : {bool, ?line('$1'), unwrap('$1')}.
boolean -> nil   : {bool, ?line('$1'), unwrap('$1')}.

%% Numbers
number -> float   : '$1'.
number -> integer : '$1'.

%% Boolean operators
bool_op -> 'and' : '$1'.
bool_op -> 'or'  : '$1'.

%% Comparison operators
comp_op -> '==' : '$1'.
comp_op -> '!=' : '$1'.
comp_op -> '>'  : '$1'.
comp_op -> '<'  : '$1'.
comp_op -> '>=' : '$1'.
comp_op -> '<=' : '$1'.
comp_op -> '=' : '$1'.

%% Addition operators
add_op -> '+'  : '$1'.
add_op -> '-'  : '$1'.

%% Multiplication operators
mult_op -> '*' : '$1'.
mult_op -> '/' : '$1'.
mult_op -> '%' : '$1'.
mult_op -> '^' : '$1'.

Erlang code.

-include("plex.hrl").
