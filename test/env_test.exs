defmodule Plex.EnvTest do
  use ExUnit.Case, async: true
  import Plex.Compiler, only: [parse!: 1]
  alias Plex.Env

  setup do
    env = Env.new(nil, %{x: 3, y: 7})
    {:ok, [env: env]}
  end

  test "bind many", %{env: env} do
    Env.bind_many(env, %{foo: 1, bar: 4})
    assert Map.equal?(Env.bindings(env), %{x: 3, y: 7, foo: 1, bar: 4})
  end

  test "env merge", %{env: env} do
    env2 = Env.new(nil, %{x: 10})
    Env.merge(env, env2)
    assert Env.bindings(env) == %{x: 10, y: 7}
  end

  test "ref set", %{env: env} do
    {:ok, ref_id} = Plex.Types.Ref.new(4)
    Env.bind(env, :num, ref_id)
    Env.ref_set!(env, :num, 10)
    assert Env.ref_get!(env, :num) == 10
  end
end
