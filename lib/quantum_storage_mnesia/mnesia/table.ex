defmodule QuantumStorageMnesia.Mnesia.Table do
  @moduledoc false

  alias Memento.Table

  @spec create!(module, [node]) :: :ok
  def create!(table, nodes) do
    :ok =
      with {:error, {:already_exists, _}} <- Table.create(table, disc_copies: nodes) do
        :ok
      end

    :ok = :mnesia.wait_for_tables([table], 15_000)
  end

  @spec clear!(module) :: :ok
  def clear!(table), do: :ok = Table.clear(table)
end
