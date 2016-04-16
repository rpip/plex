# Plex

Plex is a simple language, like Lua with some Ocaml feels. It is based on a notion of objects as extensible records. And since "everything is an object", a value may behave simultaneously as an integer, boolean, function.

It's inspired by [Andrej Bauer's Boa](http://www.andrej.com/plzoo/html/boa.html), but Plex aims to be more functional. Plex variabes are actually bindings, so variables are immutable. As in Ocaml, a list is an immutable, finite sequence of elements of the same type.

Plex supports eager evaluation, optional lazy evaluation, first-class functions, and dynamic types.

_Work in Progress_


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
