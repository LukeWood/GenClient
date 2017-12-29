defmodule GenClient.Util do
  def n_args(1), do: []
  def n_args(arity), do: Enum.map(Range.new(1, arity-1), &create_arg/1)

  defp create_arg(number) do
    name = String.to_atom("arg#{number}")
    {name, [], Elixir}
  end
end
