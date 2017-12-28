defmodule GenClient.ClientGeneration do

  #TODO(lukewood) use the real function names from the impl
  def generate_client_definitions(function) do
    function_name = elem(function, 0)
    arity = elem(function, 1)

    client_args = generate_client_args(arity)
    call_args = call_args(client_args, function_name)
    pid_arg = Enum.at(client_args, 0)

    quote do
      def unquote(function_name)(unquote_splicing(client_args)) do
        GenServer.call(unquote(pid_arg), {unquote_splicing(call_args)})
      end
    end
  end

  defp call_args(client_args, function_name) do
    [_h | t] = client_args
    [function_name] ++ t
  end

  defp generate_arg(number) do
    name = String.to_atom("arg#{number}")
    {name, [], Elixir}
  end

  defp generate_client_args(arity) do
    arity = arity - 1
    args = [{:pid, [], Elixir}]

    other_args = if arity >= 1 do
      Enum.map(Range.new(1, arity), &(generate_arg(&1)))
    else
      []
    end

    args ++ other_args
  end

end
