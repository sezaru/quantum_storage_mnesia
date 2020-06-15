defmodule Test.QuantumStorageMnesiaTest do
  @moduledoc false

  use ExUnit.Case

  import Assertions, only: [assert_lists_equal: 2]

  @storage Test.QuantumStorageMnesia.Storage

  setup [:setup_mnesia, :start_storage]

  describe "add_job/2" do
    test "adds a job" do
      job_1 = Scheduler.new_job()

      assert :ok = QuantumStorageMnesia.add_job(@storage, job_1)
      assert [^job_1] = QuantumStorageMnesia.jobs(@storage)

      job_2 = Scheduler.new_job()

      assert :ok = QuantumStorageMnesia.add_job(@storage, job_2)
      assert_lists_equal [job_1, job_2], QuantumStorageMnesia.jobs(@storage)
    end
  end

  describe "jobs/1" do
    test "returns :not_applicable if not initialized" do
      assert :not_applicable = QuantumStorageMnesia.jobs(@storage)
    end

    test "returns available jobs" do
      job_1 = Scheduler.new_job()
      job_2 = Scheduler.new_job()

      assert :ok = QuantumStorageMnesia.add_job(@storage, job_1)
      assert :ok = QuantumStorageMnesia.add_job(@storage, job_2)

      assert_lists_equal [job_1, job_2], QuantumStorageMnesia.jobs(@storage)
    end
  end

  describe "delete_job/2" do
    test "deletes a job" do
      job_1 = Scheduler.new_job()

      assert :ok = QuantumStorageMnesia.add_job(@storage, job_1)
      assert :ok = QuantumStorageMnesia.delete_job(@storage, job_1.name)
      assert [] = QuantumStorageMnesia.jobs(@storage)

      job_1 = Scheduler.new_job()
      job_2 = Scheduler.new_job()

      assert :ok = QuantumStorageMnesia.add_job(@storage, job_1)
      assert :ok = QuantumStorageMnesia.add_job(@storage, job_2)
      assert :ok = QuantumStorageMnesia.delete_job(@storage, job_2.name)
      assert [^job_1] = QuantumStorageMnesia.jobs(@storage)
    end

    test "does not fail when deleting unknown job" do
      job = Scheduler.new_job()

      assert :ok = QuantumStorageMnesia.add_job(@storage, job)
      assert :ok = QuantumStorageMnesia.delete_job(@storage, make_ref())
    end
  end

  describe "update_job_state/3" do
    test "updates a job" do
      job = Scheduler.new_job()

      assert :ok = QuantumStorageMnesia.add_job(@storage, job)
      assert :ok = QuantumStorageMnesia.update_job_state(@storage, job.name, :inactive)
      assert [%{state: :inactive}] = QuantumStorageMnesia.jobs(@storage)
    end

    test "does not fail when updating unknown job" do
      job = Scheduler.new_job()

      assert :ok = QuantumStorageMnesia.add_job(@storage, job)
      assert :ok = QuantumStorageMnesia.update_job_state(@storage, make_ref(), :inactive)
      assert [%{state: :active}] = QuantumStorageMnesia.jobs(@storage)
    end
  end

  describe "update_last_execution_date/2" do
    test "sets time on scheduler" do
      date_1 = NaiveDateTime.utc_now()

      assert :ok = QuantumStorageMnesia.update_last_execution_date(@storage, date_1)
      assert ^date_1 = QuantumStorageMnesia.last_execution_date(@storage)

      date_2 = NaiveDateTime.utc_now()

      assert :ok = QuantumStorageMnesia.update_last_execution_date(@storage, date_2)
      assert ^date_2 = QuantumStorageMnesia.last_execution_date(@storage)
    end
  end

  describe "last_execution_date/1" do
    test "gets time" do
      date = NaiveDateTime.utc_now()

      assert :ok = QuantumStorageMnesia.update_last_execution_date(@storage, date)
      assert ^date = QuantumStorageMnesia.last_execution_date(@storage)
    end

    test "gets :unknown if no time exists" do
      assert :unknown = QuantumStorageMnesia.last_execution_date(@storage)
    end
  end

  describe "purge/1" do
    test "clears whole table" do
      job = Scheduler.new_job()
      date = NaiveDateTime.utc_now()

      assert :ok = QuantumStorageMnesia.add_job(@storage, job)
      assert :ok = QuantumStorageMnesia.update_last_execution_date(@storage, date)

      assert :ok = QuantumStorageMnesia.purge(@storage)

      assert :not_applicable = QuantumStorageMnesia.jobs(@storage)
      assert :unknown = QuantumStorageMnesia.last_execution_date(@storage)
    end
  end

  defp setup_mnesia(_), do: Helper.setup_mnesia!()

  defp start_storage(_) do
    start_supervised!({QuantumStorageMnesia, name: @storage})

    on_exit(fn ->
      :code.delete(@storage)
      :code.purge(@storage)
    end)
  end
end
