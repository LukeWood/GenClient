ExUnit.start()

defmodule TestModule.Impl do
  def increment(5), do: -5
  def increment(state), do: helper(state)

  defp helper(state), do: state + 1

  def increment_by(state, num), do: state + num
  def increment_by(state), do: state + 5
  def peek(state), do: {state, state}
end

defmodule TestModule do
  use GenClient, for: TestModule.Impl,
                  calls: [:peek],
                  casts: [:increment, :increment_by]
end
