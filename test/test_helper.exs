ExUnit.start()


defmodule TestModule.Impl do
  def increment(state), do: helper(state)

  defp helper(state), do: state + 1
end

defmodule TestModule do
  use GenClient, for: TestModule.Impl
end
