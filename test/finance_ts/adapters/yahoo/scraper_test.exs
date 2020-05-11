defmodule FinanceTS.Adapters.Yahoo.ScraperTest do
  use Platform.DataCase

  alias FinanceTS.Adapters.Yahoo.Scraper

  setup do
    Tesla.Mock.mock(fn
      %{method: :get, url: "https://finance.yahoo.com/quote/aapl"} ->
        %Tesla.Env{status: 200, body: File.read!("test/support/yahoo_finance/aapl.html")}
    end)

    :ok
  end

  describe "#general_financial_data" do
    test "test aapl" do
      {:ok, result} = Scraper.general_financial_data("aapl")
      assert result.symbol == "aapl"
      assert result.outstanding_shares == 4_375_479_808
    end
  end
end
