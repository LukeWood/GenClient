defmodule GenClient do
  defmacro __using__(for: module, calls: calls, casts: casts) do

    module_expanded = Macro.expand(module, __ENV__)
    functions = module_expanded.__info__(:functions)

    calls = Enum.filter(functions, fn
      {name, _arity} -> Enum.member?(calls, name)
      _ -> false
    end)
    casts = Enum.filter(functions, fn
      {name, _arity} -> Enum.member?(casts, name)
      _ -> false
    end)

    client_call_definitions = Enum.map(calls,
      &GenClient.ClientGeneration.generate_client_call_definitions/1
    )
    client_cast_definitions = Enum.map(casts,
      &GenClient.ClientGeneration.generate_client_cast_definitions/1
    )

    server_call_definitions = Enum.map(calls,
      &GenClient.CallGeneration.generate_call_definitions(module, &1)
    )
    server_cast_definitions = Enum.map(casts,
      &GenClient.CastGeneration.generate_cast_definitions(module, &1)
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

end
