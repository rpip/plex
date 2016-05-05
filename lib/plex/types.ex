defmodule Plex.Types do
  def list?(ast) do
  end

  def tuple?(ast) do
  end

  def record?(ast) do
  end

  def function?(ast) do
  end

  def atom?(ast) do
  end

  def ref?(ast) do
  end

  def float?(ast) do
  end

  def integer?(ast) do
    true
  end
end


defmodule Plex.Types.Ref do
  @moduledoc "Mutable variable"

  alias __MODULE__
  alias Plex.Compiler.Node.ValueFunc

  @type t :: %Ref{contents: any}

  defstruct [:contents]

  @spec new(any) :: pid
  def new(value) do
    with {:ok, pid} <- Agent.start_link(fn -> %Ref{contents: value} end) do
      pid
    end
  end

  def deref(%ValueFunc{value: pid}) do
    Agent.get(pid, fn ref -> ref.contents end)
  end

  @spec deref(pid) :: Ref.t
  def deref(pid) do
    Agent.get(pid, fn ref -> ref.contents end)
  end

  def update(%ValueFunc{value: pid}, new_val) do
    Agent.update(pid, fn ref -> %{ref | contents: new_val} end)
  end

  @spec update(pid, any) :: Ref.t
  def update(pid, new_val) do
    Agent.update(pid, fn ref -> %{ref | contents: new_val} end)
  end
end
