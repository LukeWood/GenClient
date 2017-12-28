defmodule GenClient do
  defmacro __using__(for: module) do

    module_expanded = Macro.expand(module, __ENV__)
    functions = module_expanded.__info__(:functions)

    client_definitions = Enum.map(functions,
      &generate_client_definitions/1
    )

     quote do
      defmodule Client do
        unquote_splicing(client_definitions)
      end
      defmodule Server do
        use GenServer
      end
    end
  end

  #TODO(lukewood) use the real function names from the impl
  defp generate_client_definitions(function) do
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
    args = [{:pid, [], Elixir}, {:state, [], Elixir}]

    other_args = if arity >= 1 do
      Enum.map(Range.new(1, arity), &(generate_arg(&1)))
    else
      []
    end

    args ++ other_args
  end


end

defmodule Placeholder do

    def generate_server_definitions(module, function) do

      function_name = elem(function, 0)
      arity = elem(function, 1)

      args = generate_call_args(function_name, arity)
      params = generate_call_params(args)

      quote do
        def handle_call(unquote(args), _from, state) do
          apply(unquote(module), unquote(function_name), [state] ++ unquote(params))
        end
      end
    end

    def generate_call_args(function_name, arity) do
      pargs = if arity >= 1 do
        Enum.map(Range.new(1, arity), &generate_arg/1)
      else
        []
      end

      args = [function_name] ++ pargs
      List.to_tuple(args)
    end


      defp generate_arg(number) do
        name = String.to_atom("arg#{number}")
        {name, [], Elixir}
      end


    def generate_call_params(args) do
      [_head | t] = args
      t
    end
end
