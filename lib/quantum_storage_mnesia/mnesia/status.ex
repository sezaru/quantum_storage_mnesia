defmodule QuantumStorageMnesia.Mnesia.Status do
  @moduledoc false

  alias Memento.Query

  @spec initialized?(module) :: boolean
  def initialized?(table) do
    case Query.read(table, :status) do
      %{value: :initialized} -> true
      _ -> false
    end
  end

  @spec initialize(module) :: :ok
  def initialize(table) do
    %{value: :initialized} = struct!(table, key: :status, value: :initialized) |> Query.write()

    :ok
  end
end
