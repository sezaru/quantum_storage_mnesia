defmodule Scheduler do
  @moduledoc false

  use Quantum, otp_app: :quantum_storage_mnesia
end

defmodule Helper do
  def setup_mnesia! do
    nodes = [node()]

    Application.ensure_all_started(:memento)

    if path = Application.get_env(:mnesia, :dir) do
      File.mkdir_p!(path)
    end

    :ok = Memento.stop()

    :ok = Memento.Schema.delete(nodes)

    Memento.Schema.create(nodes)

    :ok = Memento.start()
  end
end

ExUnit.start()
