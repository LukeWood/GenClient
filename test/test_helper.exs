ExUnit.start()

defmodule TestModule do

end

defmodule TestModule.Impl do
  def increment(state), do: helper(state)

  defp helper(state), do: state + 1
end
