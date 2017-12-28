defmodule GenClient do
  defmacro __using__(for: module) do
    module_expanded = Macro.expand(module, __ENV__)

    functions = module_expanded.__info__(:functions)
    client_definitions = Enum.map(functions, &generate_client_definitions/1)
    server_definitions = Enum.map(functions, &generate_server_definitions/1)

    quote do
      unquote(client_definitions)
      unquote(server_definitions)
    end
  end

  defp generate_client_definitions(function) do
    quote do
      def meow() do
        IO.inspect("MEOW")
      end
    end
  end

  defp generate_server_definitions(_function) do
    args = {:meow}
    function = fn x->x+1 end
    quote do
      def handle_call(unquote(args), _from, state) do
        unquote(function(state))
      end
    end
  end
end
