defmodule QuantumStorageMnesia do
  @moduledoc """
  `Mnesia` based implementation of a `Quantum.Storage`.
  """

  alias QuantumStorageMnesia.Server

  alias Quantum.Storage

  @behaviour Storage

  @doc false
  @impl Storage
  defdelegate child_spec(args), to: Server

  @doc false
  @impl Storage
  def jobs(storage_pid), do: GenServer.call(storage_pid, :jobs, :infinity)

  @doc false
  @impl Storage
  def add_job(storage_pid, job), do: GenServer.call(storage_pid, {:add_job, job})

  @doc false
  @impl Storage
  def delete_job(storage_pid, job_name), do: GenServer.call(storage_pid, {:delete_job, job_name})

  @doc false
  @impl Storage
  def update_job_state(storage_pid, job_name, state),
    do: GenServer.call(storage_pid, {:update_job_state, job_name, state})

  @doc false
  @impl Storage
  def last_execution_date(storage_pid),
    do: GenServer.call(storage_pid, :last_execution_date, :infinity)

  @doc false
  @impl Storage
  def update_last_execution_date(storage_pid, last_execution_date),
    do: GenServer.call(storage_pid, {:update_last_execution_date, last_execution_date})

  @doc false
  @impl Storage
  def purge(storage_pid), do: GenServer.call(storage_pid, :purge)
end
