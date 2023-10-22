defmodule ApiPlaygroundTest do
  use ExUnit.Case
  doctest ApiPlayground

  test "greets the world" do
    assert ApiPlayground.hello() == :world
  end
end
