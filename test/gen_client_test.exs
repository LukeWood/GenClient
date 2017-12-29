defmodule GenClientTest do
  use ExUnit.Case

  test "GenClient generates TestModule methods" do
    increment_created = Enum.any?(TestModule.__info__(:functions), fn
      {:increment, 1} -> true
      _ -> false
    end)
    assert increment_created

    increment_by_created = Enum.any?(TestModule.__info__(:functions), fn
      {:increment_by, 2} -> true
      _ -> false
    end)
    assert increment_by_created
  end

  test "GenClient can be used with GenServer.start" do
    {:ok, pid} = GenServer.start(TestModule.Server, 0)
    TestModule.increment(pid)
    assert TestModule.peek(pid) == 1

    TestModule.increment_by(pid, 5)
    assert TestModule.peek(pid) == 6

    TestModule.increment_by(pid)
    assert TestModule.peek(pid) == 11
  end

  test "increment at 5 inverts" do
    {:ok, pid} = GenServer.start(TestModule.Server, 0)
    TestModule.increment_by(pid, 5)
    assert TestModule.peek(pid) == 5

    TestModule.increment(pid)
    assert TestModule.peek(pid) == -5
  end
end
