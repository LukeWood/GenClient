# GenClient
GenClient is an elixir library made to generate boilerplate code that I found myself repeatedly writing and changing when working with GenServers.

Every time I wanted to add or remove a parameter from a GenServer module I needed to do so in several places.

GenClient is a metaprogramming library that helps the programmer write their logic in a single location and keep it there.

### Adding as a mix dependency
```elixir
  def deps do
    [{:gen_client, git:"https://github.com/LukeWood/GenClient"}]
  end
```

### Example
Here is a module written using a standard GenServer implementation

###### counter.ex
```elixir
defmodule Counter do
  defdelegate increment(pid), to: Client
  defdelegate peek(pid),      to: CLient
end
```
###### counter/client.ex
```elixir
defmodule Counter.Client do

  def increment() do
    GenServer.cast(pid. :increment)
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

  def handle_call(:peek, _from, state) do
    {:reply, state, state}
  end
end
```
###### counter/impl.ex
Obviously this is unneccesary in the case of a counter but in more complex
applications it is nice to separate the state manipulation logic from the GenServer
logic
```elixir
defmodule Counter.Impl do
  def increment(state), do: state + 1
end
```

# The Previous Module Can be written using GenClient as follows:

```elixir
defmodule Counter do
  use GenClient,
    for: Counter.Impl,
    calls: [:peek],
    casts: [:increment, :increment_by]
end

defmodule Counter.Impl do
  def increment(state), do: state + 1
  def peek(state), do: state
end
```

###### The resulting api should be exactly the same
