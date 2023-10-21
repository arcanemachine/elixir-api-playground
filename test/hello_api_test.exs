defmodule HelloApiTest do
  use ExUnit.Case
  doctest HelloApi

  test "greets the world" do
    assert HelloApi.hello() == :world
  end
end
