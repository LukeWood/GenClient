defmodule GenClientTest do
  use ExUnit.Case

  test "GenClient generates TestModule.Client methods" do
    increment_created = Enum.any?(TestModule.Client.__info__(:functions), fn
      {:increment, 2} -> true
      _ -> false
    end)
    assert increment_created

    increment_by_created = Enum.any?(TestModule.Client.__info__(:functions), fn
      {:increment_by, 3} -> true
      _ -> false
    end)
    assert increment_by_created
  end

  test "GenClient in testmodule" do
    TestModule.Server.handle_call({:increment}, self(), 1) |> IO.inspect
  end

  test "TestModule.Client test" do
    TestModule.Client.increment()
  end
end
