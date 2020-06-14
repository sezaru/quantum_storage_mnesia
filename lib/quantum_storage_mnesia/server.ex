defmodule QuantumStorageMnesia.Server do
  @moduledoc false

  alias QuantumStorageMnesia.Impl

  use GenServer

  @doc false
  def start_link(opts) do
    name = Keyword.fetch!(opts, :name)

    GenServer.start_link(__MODULE__, name, name: name)
  end

  @doc false
  @impl GenServer
  def init(name), do: {:ok, Impl.init(name)}

  @doc false
  @impl GenServer
  def handle_call(:jobs, _, state), do: {:reply, Impl.jobs(state), state}

  def handle_call({:add_job, job}, _, state), do: {:reply, :ok, Impl.add_job(job, state)}

  def handle_call({:delete_job, job_name}, _, state),
    do: {:reply, :ok, Impl.delete_job(job_name, state)}

  def handle_call({:update_job_state, job_name, job_state}, _, state),
    do: {:reply, :ok, Impl.update_job_state(job_name, job_state, state)}

  def handle_call(:last_execution_date, _, state),
    do: {:reply, Impl.last_execution_date(state), state}

  def handle_call({:update_last_execution_date, last_execution_date}, _, state),
    do: {:reply, :ok, Impl.update_last_execution_date(last_execution_date, state)}

  def handle_call(:purge, _, state), do: {:reply, :ok, Impl.purge(state)}
end
