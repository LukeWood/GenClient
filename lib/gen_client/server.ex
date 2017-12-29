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
    {function_name, parameters, state_arg, args} = setup_definition(function)

    quote do
      def handle_call({unquote_splicing(parameters)}, _from, unquote(state_arg)) do
        result = apply(unquote(module), unquote(function_name), [unquote_splicing(args)])
        {:reply, result, result}
      end
    end
  end

  def cast_definition(module, function) do
    {function_name, parameters, state_arg, args} = setup_definition(function)

    quote do
      def handle_cast({unquote_splicing(parameters)}, unquote(state_arg)) do
        result = apply(unquote(module), unquote(function_name), [unquote_splicing(args)])
        {:noreply, result}
      end
    end
  end

  def setup_definition(function) do
    {function_name, arity} = function
    parameters = make_parameters(arity, function_name)

    state_arg = {:state, [], Elixir}

    [_head | args] = parameters
    args = [state_arg] ++ args

    {function_name, parameters, state_arg, args}
  end

  defp make_parameters(arity, function_name) do
    [function_name] ++ n_args(arity)
  end

  defp n_args(1), do: []
  defp n_args(arity), do: Enum.map(Range.new(1, arity-1), &create_arg/1)

  defp create_arg(number) do
    name = String.to_atom("arg#{number}")
    {name, [], Elixir}
  end
end
