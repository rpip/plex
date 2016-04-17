# Plex

Plex is a simple language, like Lua with some Ocaml feels. It is based on a notion of objects as extensible records. And since "everything is an object", a value may behave simultaneously as an integer, boolean, function.

It's inspired by [Andrej Bauer's Boa](http://www.andrej.com/plzoo/html/boa.html), but Plex aims to be more functional. Plex variabes are actually bindings, so variables are immutable. As in Ocaml, a list is an immutable, finite sequence of elements of the same type.

Plex supports eager evaluation, optional lazy evaluation, first-class functions, and dynamic types.

_Work in Progress_

## What it looks like

```ocaml
plex> let x = 3 with fn y -> y + 10
<Var x>
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
plex> # Examples of function application
plex> (fn x, y -> x + y) 1, 2
plex> (fn x -> x + 10) 4
plex> let greeting = "Good morning" in fn -> print greeting
plex> let maths = load('maths')
plex> maths.sum [1,2,3]
plex> (fn -> x + y), 10
plex> maths.add fn -> x + y, 10
```

## Try it

```bash
$ git clone https://github.com/rpip/plex && cd plex
$ mix escript.build
$ ./plex test/hello.plx
$ # To start the REPL
$ ./plex
Plex (0.0.1)
/help - Print this help message
/quit - Exit the REPL
/lex  - Tokenize code
/pp   - Tokenize and parse code
plex (1)>
```

### Windows

  1. Download and install git from https://git-scm.com/download/win.
  2. Download and install elixir from http://elixir-lang.org/install.html in order to use mix.
  3. Start git bash from command line. You can search for it from the windows start menu as well.
  4. Type the following in git bash:

```bash
$ git clone https://github.com/rpip/plex && cd plex
$ mix escript.build
$ ./plex test/hello.plx
$ ./plex
Plex (0.0.1)
/help - Print this help message
/quit - Exit the REPL
/lex  - Tokenize code
/pp   - Tokenize and parse code
plex (1)>
```
  5. Refer to "What it looks like above and start hacking"!


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
