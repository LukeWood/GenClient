defmodule GenClientTest do
  use ExUnit.Case
  doctest GenClient

  test "greets the world" do
    assert GenClient.hello() == :world
  end
end
