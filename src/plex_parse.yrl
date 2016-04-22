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
  let_expr
  case_expr
  clauses
  clause
  pattern
  arith
  record
  bindings
  binding
  list
  elems
  elem
  boolean
  number
  project
  function
  apply
  args
  params
  unary_op
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
  '..' 'not' 'let' 'with' 'in' '->' '.' 'fn' 'if' 'then' 'else' '!' '<=' '>='
  'and' 'or' 'for' 'do' 'while' 'end' 'case' true false integer float string
  nil identifier eol atom string_interpolate
  .

Rootsymbol root.

Left     100 'or'.
Left     110 'and'.
%% (1 + 2 * 3 -4) :: sub -> plus -> mul
Left     210 '+' '-'.
Left     220 '*' '/'.
Nonassoc 300 'not'.
Left     310 '.'.
Nonassoc 400 '==' '!=' '>=' '<=' '>' '<'.


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
expr -> list : '$1'.
expr -> if_expr : '$1'.
expr -> let_expr : '$1'.
expr -> apply : '$1'.

expr -> applicable: '$1'.
applicable -> project : '$1'.
applicable -> identifier : '$1'.
applicable -> function : '$1'.
applicable -> '(' applicable ')': '$2'.


expr -> for_expr : '$1'.
expr -> while_expr : '$1'.
expr -> case_expr : '$1'.
expr -> range_expr : '$1'.
expr -> '(' expr ')' : '$2'.
expr -> ref_update : '$1'.
expr -> deref : '$1'.
expr -> string_interpolate :
  build_ast_node('Interpolate', #{
     line => ?line('$1'),
     body => '$1'
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

%% references
deref -> '!' dereferable :
  build_ast_node('Deref', #{
     line => ?line('$1'),
     name => '$2'
  }).
ref_update -> dereferable ':=' expr :
  build_ast_node('UpdateRef', #{
     line  => ?line('$1'),
     name  => '$1',
     value => '$3'
  }).
dereferable -> identifier : '$1'.
dereferable -> project : '$1'.

%% Applications
apply -> applicable '(' ')':
  build_ast_node('Apply', #{
    line => ?line('$1'),
    applicant => '$1'
   }).
apply -> applicable args :
  build_ast_node('Apply', #{
    line => ?line('$1'),
    applicant => '$1',
    args => ['$2']
   }).
apply -> applicable '(' args ')':
  build_ast_node('Apply', #{
    line => ?line('$1'),
    applicant => '$1',
    args => ['$3']
   }).

args -> params : '$1'.

%% range
range_expr -> integer '..' integer :
  build_ast_node('Range', #{
     line  => ?line('$1'),
     first =>'$1',
     last  => '$3'
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
elem  -> record : '$1'.
elem  -> function : '$1'.
elem  -> apply : '$1'.
elem  -> list : '$1'.
elem  -> string : '$1'.
elem  -> number : '$1'.
elem  -> atom : '$1'.
elem  -> boolean : '$1'.
elem  -> project : '$1'.
elem  -> arith : '$1'.
elem  -> deref : '$1'.
elem  -> identifier : '$1'.

%% Tuples
record -> '{' elems '}'       :
  build_ast_node('Tuple', #{
     line => ?line('$1'),
     elements => to_tuple('$2')
    }).

%% Records
record -> '{' '}' : build_ast_node('Record', #{line => ?line('$1')}).
record -> '{' bindings '}' :
  build_ast_node('Record', #{
     line => ?line('$1'),
     properties => '$2'
    }).
binding  -> identifier '=' expr  : {'$1', '$3'}.
binding  -> identifier '=' expr 'with' record : {'$1', '$3', '$5'}.
binding  -> identifier '=' expr 'with' function : {'$1', '$3', '$5'}.
bindings -> binding  : ['$1'].
bindings -> binding ',' bindings : ['$1'|'$3'].

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
params -> expr : ['$1'].
params -> expr ',' params : ['$1'|'$3'].

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

clause -> pattern '->' expr : [{'$1','$3'}].
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
pattern -> range_expr : '$1'.


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
boolean -> unary_op expr :
  build_ast_node('UnaryOp', #{
    line => ?line('$1'),
    type => ?op('$1'),
    arg  => '$2'
   }).
arith -> expr add_op expr	:
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
boolean -> expr comp_op expr   :
 build_ast_node('BinaryOp', #{
    line => ?line('$1'),
    type => ?op('$2'),
    left => '$1',
    right => '$3'
   }).
boolean -> expr bool_op expr  :
  build_ast_node('BinaryOp', #{
    line  => ?line('$1'),
    type  => ?op('$2'),
    left  => '$1',
    right => '$3'
  }).

%% Boolean values
boolean -> true  : '$1'.
boolean -> false : '$1'.
boolean -> nil   : '$1'.

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

%% Unary operators
unary_op -> 'not' : '$1'.

Erlang code.

-include("plex.hrl").
