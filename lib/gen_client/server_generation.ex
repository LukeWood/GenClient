
defmodule GenClient.ServerGenerations do

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
