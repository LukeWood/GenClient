defmodule GenClientTest do
  use ExUnit.Case

  test "GenClient in testmodule" do
    TestModule.handle_call({:meow}, self(), 1) |> IO.inspect
  end
end
