defmodule GenClient do
  defmacro __using__(for: module) do
    module_expanded = Macro.expand(module, __ENV__)

    functions = module_expanded.__info__(:functions)
    IO.inspect functions
  end
end
