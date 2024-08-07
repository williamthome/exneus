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

  test "decode" do
    assert Exneus.decode!("null") == nil
    assert Exneus.decode!(~s({"foo":"bar","bar":"baz"})) == %{"bar" => "baz", "foo" => "bar"}

    assert Exneus.decode!(~s({"foo":"bar","bar":"baz"}), %{object_finish: :keyword_list}) ==
             [{"foo", "bar"}, {"bar", "baz"}]

    assert Exneus.decode!(~s({"foo":"bar","bar":"baz"}), %{object_finish: :reversed_keyword_list}) ==
             [{"bar", "baz"}, {"foo", "bar"}]
  end
end
