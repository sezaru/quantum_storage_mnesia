defmodule QuantumStorageMnesia.Mnesia.LastDate do
  alias Memento.Query

  @spec add_or_update(module, NaiveDateTime.t()) :: NaiveDateTime.t()
  def add_or_update(table, last_date) do
    %{value: last_date} = struct!(table, key: :last_date, value: last_date) |> Query.write()

    last_date
  end

  @spec get(module) :: NaiveDateTime.t() | nil
  def get(table) do
    with %{value: last_date} <- Query.read(table, :last_date) do
      last_date
    end
  end
end
