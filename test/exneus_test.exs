defmodule ExneusTest do
  defmodule Struct do
    defstruct name: "Joe", age: 68
  end

  use ExUnit.Case
  doctest Exneus

  test "encode" do
    assert Exneus.encode!(nil) == "null"
    assert Exneus.encode!([foo: :bar], %{keyword_lists: true}) == ~s({"foo":"bar"})
    assert Exneus.encode!(%Struct{}) == ~s({"name":"Joe","age":68})
  end
end
