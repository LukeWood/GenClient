defmodule GenClientTest do
  use ExUnit.Case

  test "GenClient generates TestModule.Client methods" do
    increment_created = Enum.any?(TestModule.Client.__info__(:functions), fn
      {:increment, 1} -> true
      _ -> false
    end)
    assert increment_created

    increment_by_created = Enum.any?(TestModule.Client.__info__(:functions), fn
      {:increment_by, 2} -> true
      _ -> false
    end)
    assert increment_by_created
  end

  test "TestModule.Server.handle_call works in testmodule" do
    assert TestModule.Server.handle_call({:increment}, self(), 1) == {:reply, 2, 2}
    assert TestModule.Server.handle_call({:increment_by, 3}, self(), 4) == {:reply, 7, 7}
  end

  test "GenClient can be used with GenServer.start" do
    {:ok, pid} = GenServer.start(TestModule.Server, 0)
    assert TestModule.Client.increment(pid) == 1
    assert TestModule.Client.increment_by(pid, 5) == 6
    # default arg of 5 for testing purposes
    assert TestModule.Client.increment_by(pid) == 11

  end
end
