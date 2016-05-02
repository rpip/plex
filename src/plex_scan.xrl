%%% @author Yao Adzaku <yao@abakhi.com>
%%% @copyright (C) 2016, Yao Adzaku
%%% @doc
%%% Leex scanner for Plex language
%%% @end
%%% Created : 16 Apr 2016 by Yao Adzaku <yao@abakhi.com>

Definitions.

U  = [A-Z]
L  = [a-z]
W  = [\s\t]
N  = [\n\r]
D  = (\+|-)?[0-9]+
DQ = "(\\\^.|\\.|[^\"])*"
SQ = '(\\\^.|\\.|[^\'])*'

Rules.

%% Identifier
({L}|_)({U}|{L}|{D}|_|\')* : build_identifier(TokenChars, TokenLine).

%% Atom
\:({U}|{L}|_)({U}|{D}|{L}|_)* : build_atom(TokenChars, TokenLine, TokenLen).
\:{DQ} : build_quoted_atom(TokenChars, TokenLine, TokenLen).
\:{SQ} : build_quoted_atom(TokenChars, TokenLine, TokenLen).

%% Numbers and Strings
{D}+\.{D}+ : build_float(TokenChars, TokenLine).
{D}+ :       build_integer(TokenChars, TokenLine).
{DQ} :       build_string(TokenChars, TokenLine).
{SQ} :       build_string(TokenChars, TokenLine).

%% Ignored
({W}+|{N}) : skip_token.

%% Comments, either -- or --[[ ]].
%% Source: https://github.com/rvirding/luerl/blob/develop/src/luerl_scan.xrl
%%--(\[([^[\n].*|\[\n|[^[\n].*|\n) : skip_token.
--\n :		skip_token.
--[^[\n].* :	skip_token.
--\[\n :	skip_token.
--\[[^[\n].* :	skip_token.
%% --aa([^b]|b[^b])*b+b
--\[\[([^]]|\][^]])*\]+\] : skip_token.
--\[\[([^]]|\][^]])* : {error,"unfinished long comment"}.


\( : {token, {'(', TokenLine}}.
\) : {token, {')', TokenLine}}.
\{ : {token, {'{', TokenLine}}.
} : {token, {'}', TokenLine}}.
\[ : {token, {'[', TokenLine}}.
\] : {token, {']', TokenLine}}.
\+ : {token, {'+', TokenLine}}.
\- : {token, {'-', TokenLine}}.
\* : {token, {'*', TokenLine}}.
/  : {token, {'/', TokenLine}}.
\% : {token, {'%', TokenLine}}.
,  : {token, {',', TokenLine}}.
\. : {token, {'.', TokenLine}}.
=  : {token, {'=', TokenLine}}.
<  : {token, {'<', TokenLine}}.
>  : {token, {'>', TokenLine}}.
!= : {token, {'!=', TokenLine}}.
;  : {token,{'eol',TokenLine}}.
:  : {token, {':', TokenLine}}.
\->  : {token, {'->', TokenLine}}.
\.\. : {token, {'..', TokenLine}}.
:= : {token, {':=', TokenLine}}.
! : {token, {'!', TokenLine}}.
| : {token, {'|', TokenLine}}.
<\= : {token, {'<=', TokenLine}}.
>=  : {token, {'>=', TokenLine}}.
\^  : {token, {'^', TokenLine}}.

Erlang code.

-export([is_keyword/1]).

build_identifier(Chars, Line) ->
    Atom = list_to_atom(Chars),
    case is_keyword(Atom) of
        true -> {token, {Atom, Line}};
        false -> {token, {identifier, Line, Atom}}
    end.

build_integer(Chars, Line) ->
    {token, {integer, Line, list_to_integer(Chars)}}.

build_float(Chars, Line) ->
  {token, {float, Line, list_to_float(Chars)}}.

build_string(Chars, Line) ->
    String = to_unicode(Chars),
    case re:run(String, "#{(.*)}", [global, {capture, all, list}]) of
        nomatch ->
            {token, {string, Line, String}};
        {match, [[_, Match]]} ->
            case Match of
                [] ->
                    {token, {string, Line, ""}};
                _ ->
                    {token, {string_interpolate, Line, Match}}
            end
    end.

build_atom(Chars, Line, Len) ->
    String = lists:sublist(Chars, 2, Len - 1),
    {token, {atom, Line, list_to_atom(String)}}.

build_quoted_atom(Chars, Line, Len) ->
    String = lists:sublist(Chars, 2, Len - 2),
    build_atom(String, Line, Len).

to_unicode(Chars) ->
    Str = string:sub_string(Chars, 2, length(Chars) - 1),
    'Elixir.String.Chars':to_string(Str).

is_keyword('and') ->
    true;
is_keyword('else') ->
    true;
is_keyword('fn') ->
    true;
is_keyword('if') ->
    true;
is_keyword('in') ->
    true;
is_keyword('let') ->
    true;
is_keyword('or') ->
    true;
is_keyword('then') ->
    true;
is_keyword('this') ->
    true;
is_keyword('true') ->
    true;
is_keyword('false') ->
    true;
is_keyword('nil') ->
    true;
is_keyword('with') ->
    true;
is_keyword('for') ->
    true;
is_keyword('do') ->
    true;
is_keyword('end') ->
    true;
is_keyword('while') ->
    true;
is_keyword('case') ->
    true;
is_keyword(_) ->
    false.
