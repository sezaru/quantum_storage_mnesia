defmodule QuantumStorageMnesia.Impl do
  @moduledoc false

  alias QuantumStorageMnesia.{Mnesia, State}

  require Mnesia

  @spec init(module) :: State.t()
  def init(name) do
    nodes = [node()]

    Mnesia.create_module(name)
    Mnesia.Table.create!(name, nodes)

    State.new(name)
  end

  @spec jobs(State.t()) :: :not_applicable | [Quantum.Job.t()]
  def jobs(%{table: table}) do
    fn ->
      if Mnesia.Status.initialized?(table) do
        Mnesia.Job.all(table)
      else
        :not_applicable
      end
    end
    |> Mnesia.Helper.transaction([])
  end

  @spec last_execution_date(State.t()) :: :unknown | NaiveDateTime.t()
  def last_execution_date(%{table: table}) do
    case Mnesia.Helper.transaction(fn -> Mnesia.LastDate.get(table) end) do
      nil -> :unknown
      last_date -> last_date
    end
  end

  @spec add_job(Quantum.Job.t(), State.t()) :: State.t()
  def add_job(job, %{table: table} = state) do
    fn ->
      Mnesia.Job.add_or_update(table, job)
      Mnesia.Status.initialize(table)
    end
    |> Mnesia.Helper.transaction!()

    state
  end

  @spec delete_job(Quantum.Job.name(), State.t()) :: State.t()
  def delete_job(job_name, %{table: table} = state) do
    Mnesia.Helper.transaction!(fn -> Mnesia.Job.delete(table, job_name) end)

    state
  end

  @spec update_job_state(Quantum.Job.name(), Quantum.Job.state(), State.t()) :: State.t()
  def update_job_state(job_name, job_state, %{table: table} = state) do
    fn ->
      with job when not is_nil(job) <- Mnesia.Job.get(table, job_name) do
        Mnesia.Job.add_or_update(table, %{job | state: job_state})
      end
    end
    |> Mnesia.Helper.transaction!()

    state
  end

  @spec update_last_execution_date(NaiveDateTime.t(), State.t()) :: State.t()
  def update_last_execution_date(last_execution_date, %{table: table} = state) do
    fn -> Mnesia.LastDate.add_or_update(table, last_execution_date) end
    |> Mnesia.Helper.transaction!()

    state
  end

  @spec purge(State.t()) :: State.t()
  def purge(%{table: table} = state) do
    Mnesia.Table.clear!(table)

    state
  end
end
