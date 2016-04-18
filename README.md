# Plex

Plex is a simple language, like Lua with some Ocaml feels. It is based on a notion of objects as extensible records. And since "everything is an object", a value may behave simultaneously as an integer, boolean, or a function.

It's inspired by [Andrej Bauer's Boa](http://www.andrej.com/plzoo/html/boa.html), but Plex aims to be more functional. Plex variabes are actually bindings, so it defaults to immutability. As in Ocaml, a list is an immutable, finite sequence of elements of the same type. As in Ocaml, there are imperative programming constructs such as `for` and `while` loops and also `ref` for getting a reference to mutable data.

Plex supports eager evaluation, optional lazy evaluation, first-class functions, and dynamic types. Where possible, Plex tries to checks type integrity of programs statically -- that is, at compile time.

[![Build Status](https://travis-ci.org/rpip/plex.svg?branch=master)](https://travis-ci.org/rpip/plex)

_Work in Progress_

## Examples

See the test directory for example code that works

## Building and running

- Install [Elixir](http://elixir-lang.org/install.html)

- Clone the repository:

```bash
$ git clone https://github.com/rpip/plex.git && cd plex
$ mix ecscript.build
```

## Run a file

`$ ./plex test/examples/hello.plx`

## REPL

Plex includes a simple REPL, which you can play around with:

```bash
$ ./plex
Erlang/OTP 18 [erts-7.1] [source] [64-bit] [smp:4:4] [async-threads:10]
Plex (0.0.1)
/h   - Print this help message
/q   - Exit the REPL
/lex - Tokenize code
/pp  - Tokenize and parse code
plex> let x = 3 with fn y -> y + 10
<Val x>
plex> x + 1
4
plex> x 2
12
plex> let x = 10 in (fn -> x + 1)
11
plex> let person = {name=nil, age=0}
<Record person>
plex> let ama = person with {name="Ama", age=20}
<Record person>
plex> ama.name
Ama
plex> let ama = ama with {age=18}
plex> ama.age
18
plex> let greet = fn name -> print "Hello #{name}"
<Func greet>
plex> greet "Joe"
Hello Joe
```

## Test Suite

To run the automated test suite:

`$ mix test`

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add plex to your list of dependencies in `mix.exs`:

        def deps do
          [{:plex, "~> 0.0.1"}]
        end

  2. Ensure plex is started before your application:

        def application do
          [applications: [:plex]]
        end
