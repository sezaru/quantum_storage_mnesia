defmodule QuantumStorageMnesia.Mnesia do
  @moduledoc false

  defmacro create_module(name) do
    quote do
      defmodule unquote(name) do
        use Memento.Table, attributes: [:key, :value]
      end
    end
  end
end
