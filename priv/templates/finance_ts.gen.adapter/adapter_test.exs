defmodule FinanceTS.<%= scoped %>AdapterTest do
  use FinanceTS.AdapterCase
  @adapter FinanceTS.<%= scoped %>Adapter

  describe "#get_info" do
    test "returns an info struct" do
      assert_exchange_info @adapter.get_info()
    end
  end

  describe "#coinlist" do
    test "get the list" do
      use_cassette "<%= path %>#coinlist" do
        assert @adapter.nothere() == []
      end
    end
  end
end
