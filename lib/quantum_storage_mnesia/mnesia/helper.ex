defmodule QuantumStorageMnesia.Mnesia.Helper do
  @spec transaction((() -> any), any) :: any
  def transaction(fun_fn, error_default \\ nil) do
    case Memento.transaction(fun_fn) do
      {:ok, value} -> value
      {:error, _} -> error_default
    end
  end

  @spec transaction!((() -> any)) :: any | no_return
  def transaction!(fun_fn), do: Memento.transaction!(fun_fn)
end
