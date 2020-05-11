defmodule FinanceTS.BundesbankAdapterTest do
  use FinanceTS.AdapterCase
  @adapter FinanceTS.BundesbankAdapter

  describe "#get_info" do
    test "returns an info struct" do
      assert_exchange_info @adapter.get_info()
    end
  end

  describe "#coinlist" do
    test "get the list" do
      use_cassette "bundesbank#coinlist" do
        assert @adapter.nothere() == []
      end
    end
  end
end
