# GenClient
GenClient is an elixir library made to generate boilerplate code that I found myself repeatedly writing and changing when working with GenServers

### Example

```elixir
defmodule Counter do
  defdelegate increment(pid), to: Client
  defdelegate peek(pid),      to: CLient
end

defmodule Counter.Client do

  def increment() do
    GenServer.cast(pid. :increment)
  end
  
  def peek() do
    GenServer.call(pid, :peek)
  end
  
end

defmodule Counter.Server do
  def handle_cast(:increment, state) do
    {:no_reply, state+1}
  end
  
  def handle_call(:peek, _from, state) do
    {:reply, state, state}
  end
end

```
