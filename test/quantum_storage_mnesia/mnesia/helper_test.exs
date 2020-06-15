defmodule Test.QuantumStorageMnesia.Mnesia.HelperTest do
  @moduledoc false

  alias QuantumStorageMnesia.Mnesia

  alias Memento.Transaction

  use ExUnit.Case

  setup [:setup_mnesia]

  describe "transaction/2" do
    test "returns `error_default` when transaction fails" do
      assert :failed = Mnesia.Helper.transaction(fn -> Transaction.abort("error") end, :failed)
    end
  end

  defp setup_mnesia(_), do: Helper.setup_mnesia!()
end
