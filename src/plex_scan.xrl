%%% @author Yao Adzaku <yao@abakhi.com>
%%% @copyright (C) 2016, Yao Adzaku
%%% @doc
%%% Leex scanner for Plex language
%%% @end
%%% Created : 16 Apr 2016 by Yao Adzaku <yao@abakhi.com>

Definitions.

UpperCase     = [A-Z]
LowerCase     = [a-z]
Whitespace    = [\s\t]
NewLine       = [\n\r]
LineComment   = (\-\-).*
BlockComment  = (\{\-)(.*\n?)+(\-})
Digit         = (\+|-)?[0-9]+
DoubleQuoted  = "(\\\^.|\\.|[^\"])*"
SingleQuoted  = '(\\\^.|\\.|[^\'])*'

Rules.

%% Identifier
({LowerCase}|_)({UpperCase}|{LowerCase}|{Digit}|_)* : build_identifier(TokenChars, TokenLine).

%% Atom
\:({UpperCase}|{LowerCase}|_)({UpperCase}|{Digit}|{LowerCase}|_)* : build_atom(TokenChars, TokenLine, TokenLen).
\:{DoubleQuoted} : build_quoted_atom(TokenChars, TokenLine, TokenLen).
\:{SingleQuoted} : build_quoted_atom(TokenChars, TokenLine, TokenLen).

%% Numbers and Strings
{Digit}+\.{Digit}+ : build_float(TokenChars, TokenLine).
{Digit}+           : build_integer(TokenChars, TokenLine).
{DoubleQuoted}     : build_string(TokenChars, TokenLine).
{SingleQuoted}     : build_string(TokenChars, TokenLine).

%% Block comment
{BlockComment} : build_block_comment(TokenChars, TokenLine, TokenLen).

%% Ignored
({LineComment}|{Whitespace}+|{NewLine}) : skip_token.

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
!  : {token, {'!', TokenLine}}.
| : {token, {'|', TokenLine}}.

Erlang code.

build_identifier(Chars, Line) ->
    Atom = list_to_atom(Chars),
    case reserved_word(Atom) of
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

build_block_comment(Chars, Line, Len) ->
    String = lists:sublist(Chars, 3, Len - 4),
    String1 = 'Elixir.String.Chars':to_string(String),
    String2 = 'Elixir.String':strip(String1),
    {token, {block_comment, Line, String2}}.

to_unicode(Chars) ->
    Str = string:sub_string(Chars, 2, length(Chars) - 1),
    'Elixir.String.Chars':to_string(Str).

reserved_word('and') ->
    true;
reserved_word('else') ->
    true;
reserved_word('fn') ->
    true;
reserved_word('if') ->
    true;
reserved_word('in') ->
    true;
reserved_word('let') ->
    true;
reserved_word('not') ->
    true;
reserved_word('or') ->
    true;
reserved_word('then') ->
    true;
reserved_word('this') ->
    true;
reserved_word('true') ->
    true;
reserved_word('false') ->
    true;
reserved_word('nil') ->
    true;
reserved_word('with') ->
    true;
reserved_word('for') ->
    true;
reserved_word('do') ->
    true;
reserved_word('end') ->
    true;
reserved_word('while') ->
    true;
reserved_word('case') ->
    true;
reserved_word(_) ->
    false.
