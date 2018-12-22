# GenClient
GenClient is an elixir library made to generate boilerplate code that I found myself repeatedly writing and changing when working with GenServers.

Every time I wanted to add or remove a parameter from a GenServer module I needed to do so in several places.

GenClient is a metaprogramming library that helps the programmer write their logic in a single location and keep it there.

### Example
Here is a module written using a standard GenServer implementation

###### counter.ex
```elixir
defmodule Counter do
  defdelegate increment(pid), to: Client
  defdelegate peek(pid),      to: Client
end
```
###### counter/client.ex
```elixir
defmodule Counter.Client do

  def increment() do
    GenServer.cast(pid, :increment)
  end

  def peek() do
    GenServer.call(pid, :peek)
  end

end
```
###### counter/server.ex
```elixir
defmodule Counter.Server do
  def handle_cast(:increment, state) do
    {:no_reply, Counter.Impl.increment(state)}
  end
  
  def handle_cast({:increment_by, x}, state) do
    {:no_reply, Counter.Impl.increment_by(state, x)}
  end
  
  def handle_call(:peek, _from, state) do
    {:reply, state, state}
  end
end
```
###### counter/impl.ex
```elixir
defmodule Counter.Impl do
  def increment(state), do: state + 1
  def increment_by(state, x), do: state + x
end
```
# The Previous Module Can be written using GenClient as follows:

###### counter.ex
```elixir
defmodule Counter do
  use GenClient,
    for: Counter.Impl,
    calls: [:peek],
    casts: [:increment, :increment_by]
end
```
###### counter/counter.impl.ex
```elixir
defmodule Counter.Impl do
  # Casts
  def increment(state), do: state + 1
  def increment_by(state, amount), do: state + amount
  
  # Calls
  def peek(state) do
    response = state
    new_state = state
    {response, new_state}
  end
  
end
```

###### The resulting api will be exactly the same

### Adding as a mix dependency
```elixir
  def deps do
    [{:gen_client, git:"https://github.com/LukeWood/GenClient"}]
  end
```
or
```elixir
def deps do
  [{:gen_client, "~> 1.0.1"}]
end
```
