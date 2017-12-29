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

  test "GenClient can be used with GenServer.start" do
    {:ok, pid} = GenServer.start(TestModule.Server, 0)
    TestModule.Client.increment(pid)
    assert TestModule.Client.peek(pid) == 1

    TestModule.Client.increment_by(pid, 5)
    assert TestModule.Client.peek(pid) == 6

    TestModule.Client.increment_by(pid)
    assert TestModule.Client.peek(pid) == 11
  end

  test "increment at 5 inverts" do
    {:ok, pid} = GenServer.start(TestModule.Server, 0)
    TestModule.Client.increment_by(pid, 5)
    assert TestModule.Client.peek(pid) == 5

    TestModule.Client.increment(pid)
    assert TestModule.Client.peek(pid) == -5
  end
end
