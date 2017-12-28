defmodule GenClientTest do
  use ExUnit.Case
  use GenClient, for: TestModule.Impl
end
