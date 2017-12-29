defmodule GenClient do
  defmacro __using__(for: module, calls: calls, casts: casts) do

    module_expanded = Macro.expand(module, __ENV__)
    calls = get_arities(module_expanded, calls)
    casts = get_arities(module_expanded, casts)

    client_call_definitions = Enum.map(calls,
      &GenClient.Client.call_definitions/1
    )
    client_cast_definitions = Enum.map(casts,
      &GenClient.Client.cast_definitions/1
    )

    server_call_definitions = Enum.map(calls,
      &GenClient.Server.call_definitions(module, &1)
    )
    server_cast_definitions = Enum.map(casts,
      &GenClient.Server.cast_definitions(module, &1)
    )

     quote do
      defmodule Client do
        unquote_splicing(client_call_definitions)
        unquote_splicing(client_cast_definitions)
      end
      defmodule Server do
        use GenServer
        unquote_splicing(server_call_definitions)
        unquote_splicing(server_cast_definitions)
      end
    end
  end

  defp get_arities(module, function_names) do
    functions = module.__info__(:functions)

    Enum.filter(functions, fn
      {name, _arity} -> Enum.member?(function_names, name)
    end)
  end

end
