# GenClient
GenClient is an elixir library made to generate boilerplate code that I found myself repeatedly writing and changing when working with GenServers

### Adding as a mix dependency
```elixir
  def deps do
    [{:genclient, git:"https://github.com/LukeWood/GenClient"}]
  end
```

### Example
The following module definition should be rewritten with GenClient as follows:
```elixir
defmodule Counter do
  defdelegate increment(pid), to: Client
  defdelegate peek(pid),      to: CLient
end
```
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
```elixir
defmodule Counter.Impl do
  def increment(state), do: state + 1
end
```

# Can be written using GenClient as follows:

```elixir
defmodule Counter do
  # Would like to prevent the need for explicit passing of calls and casts to give a slightly nicer API
  use GenClient, for: Counter.Impl,
    calls: [:peek],
    casts: [:increment, :increment_by]
end

defmodule Counter.Impl do
  def increment(state), do: state + 1
  def peek(state), do: state
end
```

###### The resulting api should be exactly the same
