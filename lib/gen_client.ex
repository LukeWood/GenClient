defmodule GenClient do
  defmacro __using__(for: module, calls: calls, casts: casts) do

    client_definitions = Enum.map(calls ++ casts,
      &GenClient.ClientGeneration.generate_client_definitions/1
    )
    call_definitions = Enum.map(calls,
      &GenClient.ServerGeneration.generate_call_definitions(module, &1)
    )

    cast_definitions = Enum.map(casts,
      &GenClient.ServerGeneration.generate_cast_definitions(module, &1)
    )

     quote do
      defmodule Client do
        unquote_splicing(client_definitions)
      end
      defmodule Server do
        use GenServer
        unquote_splicing(call_definitions)
        unquote_splicing(cast_definitions)
      end
    end
  end

end
