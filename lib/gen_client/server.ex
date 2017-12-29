defmodule GenClient.Server do

  def create(calls, casts) do
    quote do
      defmodule Server do
        use GenServer
        unquote_splicing(calls)
        unquote_splicing(casts)
      end
    end
  end

  def call_definition(module, function) do
    function_name = elem(function, 0)
    arity = elem(function, 1)

    server_args = generate_server_args(arity, function_name)

    state_arg = {:state, [], Elixir}
    call_args = [state_arg] ++ call_args(server_args)

    quote do
      def handle_call({unquote_splicing(server_args)}, _from, unquote(state_arg)) do
        result = apply(unquote(module), unquote(function_name), [unquote_splicing(call_args)])
        {:reply, result, result}
      end
    end
  end

  def cast_definition(module, function) do
    function_name = elem(function, 0)
    arity = elem(function, 1)

    server_args = generate_server_args(arity, function_name)

    state_arg = {:state, [], Elixir}
    call_args = [state_arg] ++ call_args(server_args)

    quote do
      def handle_cast({unquote_splicing(server_args)}, unquote(state_arg)) do
        result = apply(unquote(module), unquote(function_name), [unquote_splicing(call_args)])
        {:noreply, result}
      end
    end
  end

  defp call_args(server_args) do
    [_head | tail] = server_args
    tail
  end

  defp generate_server_args(arity, function_name) do
    arity = arity - 1
    args = [function_name]

    other_args = if arity >= 1 do
      Enum.map(Range.new(1, arity), &(generate_arg(&1)))
    else
      []
    end
    args ++ other_args

  end

  defp generate_arg(number) do
    name = String.to_atom("arg#{number}")
    {name, [], Elixir}
  end
end
