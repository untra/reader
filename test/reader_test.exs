defmodule ReaderTest do
  use ExUnit.Case
  doctest Reader

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "sanitize_word" do
    assert Reader.sanitize_word("Foo!") == "foo"
  end

end
