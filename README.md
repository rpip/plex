# Plex

Plex is a simple programming language.

Plex started as a port of [Andrej Bauer's Boa](http://www.andrej.com/plzoo/html/boa.html), but the language has since changed in significant ways to include ideas from Ocaml and Haskell. As such, it's syntax and semantics draws heavily from these languages, but is a bit simpler and more streamlined.

The main goal of Plex is to be a learning project. It may become a more serious effort at some point in the future, but for now it is little more than a hobbyist's project.

[![Build Status](https://travis-ci.org/rpip/plex.svg?branch=master)](https://travis-ci.org/rpip/plex)

_Work in Progress_

## Examples

See the test directory for example code that works

## Building and running

- Install [Elixir](http://elixir-lang.org/install.html)

- Clone the repository:

```bash
$ git clone https://github.com/rpip/plex.git && cd plex
$ mix escript.build
```

## Run a file

`$ ./plex test/examples/hello.px`

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
plex> let greet name = print "Hello #{name}"
<Func greet>
plex> greet "Joe"
Hello Joe
```

## Test Suite

To run the automated test suite:

`$ mix test`

## Documentation

You can build the project source docs locally by running `MIX_ENV=docs mix docs`.

To learn more about the language specification, see the [wiki](https://github.com/rpip/plex/wiki) pages.

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
