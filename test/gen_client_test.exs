defmodule GenClientTest do
  use ExUnit.Case

  test "GenClient in testmodule" do
    TestModule.handle_call({:increment}, self(), 1) |> IO.inspect
  end
end
