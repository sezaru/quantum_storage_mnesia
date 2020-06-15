defmodule QuantumStorageMnesia.Mnesia.Job do
  @moduledoc false

  alias Memento.Query

  @spec add_or_update(module, Quantum.Job.t()) :: Quantum.Job.t()
  def add_or_update(table, %{name: name} = job) do
    %{value: job} = struct!(table, key: {:job, name}, value: job) |> Query.write()

    job
  end

  @spec get(module, Quantum.Job.name()) :: Quantum.Job.t() | nil
  def get(table, job_name) do
    with %{value: job} <- Query.read(table, {:job, job_name}) do
      job
    end
  end

  @spec all(module) :: [Quantum.Job.t()]
  def all(table) do
    match_head = {table, {:job, :_}, :"$1"}
    result = [:"$1"]

    Query.select_raw(table, [{match_head, [], result}], coerce: false)
  end

  @spec delete(module, Quantum.Job.name()) :: :ok
  def delete(table, job_name), do: Query.delete(table, {:job, job_name})
end
