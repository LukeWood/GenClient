defmodule GenClient do
  defmacro __using__(for: module) do

    module_expanded = Macro.expand(module, __ENV__)
    functions = module_expanded.__info__(:functions)

    client_definitions = Enum.map(functions,
      &GenClient.ClientGeneration.generate_client_definitions/1
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

end
