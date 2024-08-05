defmodule ExneusTest do
  use ExUnit.Case
  doctest Exneus

  test "greets the world" do
    assert Exneus.hello() == :world
  end
end
