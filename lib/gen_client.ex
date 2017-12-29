defmodule GenClient do

  @moduledoc """
    The GenClient module is to be used with the use macro.

    GenClient handles the interface between your state management logic and
    the GenServer library.
  """

  defmacro __using__(for: module, calls: calls, casts: casts) do
    module_expanded = Macro.expand(module, __ENV__)
    calls = Macro.expand(calls, __ENV__)
    casts = Macro.expand(casts, __ENV__)

    calls = get_arities(module_expanded, calls)
    casts = get_arities(module_expanded, casts)

    client_calls = Enum.map(calls, &GenClient.Client.call_definition/1)
    client_casts = Enum.map(casts, &GenClient.Client.cast_definition/1)
    server_calls = Enum.map(calls, &GenClient.Server.call_definition(module, &1))
    server_casts = Enum.map(casts, &GenClient.Server.cast_definition(module, &1))

    client = GenClient.Client.create(client_calls, client_casts)
    server = GenClient.Server.create(server_calls, server_casts)
    quote do
      unquote(client)
      unquote(server)
    end
  end

  defp get_arities(module, function_names) do
    functions = module.__info__(:functions)

    Enum.filter(functions, fn
      {name, _arity} -> Enum.member?(function_names, name)
    end)
  end

end
