defmodule QuantumStorageMnesia.State do
  @moduledoc false

  @type t :: %__MODULE__{table: module}

  @enforce_keys [:table]
  defstruct [:table]

  def new(table), do: struct!(__MODULE__, table: table)
end
