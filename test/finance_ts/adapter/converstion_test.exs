defmodule FinanceTS.Adapter.ConversionTest do
  use ExUnit.Case, async: true

  alias FinanceTS.Adapter.Conversion

  describe "#to_ts" do
    test "returns" do
      assert Conversion.to_ts(315_532_800) == 315_532_800
      assert Conversion.to_ts(~U[1980-01-01T00:00:00Z]) == 315_532_800
      assert Conversion.to_ts("1980-01-01") == 315_532_800
      assert Conversion.to_ts("19800101") == 315_532_800
    end
  end
end
