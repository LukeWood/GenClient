defmodule GenClient.Client do

  def create(calls, casts) do
    quote do
      unquote_splicing(calls)
      unquote_splicing(casts)
    end
  end

  def call_definition(function) do
    {function_name, params, fn_args, pid_arg} = setup_definition(function)
    quote do
      def unquote(function_name)(unquote_splicing(params)) do
        GenServer.call(unquote(pid_arg), {unquote_splicing(fn_args)})
      end
    end
  end

  def cast_definition(function) do
    {function_name, params, fn_args, pid_arg} = setup_definition(function)
    quote do
      def unquote(function_name)(unquote_splicing(params)) do
        GenServer.cast(unquote(pid_arg), {unquote_splicing(fn_args)})
      end
    end
  end

  def setup_definition({function_name, arity}) do
    pid_arg = {:pid, [], Elixir}
    fn_args = GenClient.Util.n_args(arity)
    params = [pid_arg] ++ fn_args

    fn_args = [function_name] ++ fn_args

    {function_name, params, fn_args, pid_arg}
  end

end
