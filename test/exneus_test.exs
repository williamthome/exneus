defmodule ExneusTest do
  use ExUnit.Case
  doctest Exneus

  test "encode" do
    assert Exneus.encode!(nil) == "null"
    assert Exneus.encode!([foo: :bar], %{keyword_lists: true}) == ~s({"foo":"bar"})
  end
end
