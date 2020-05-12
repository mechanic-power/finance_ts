defmodule FinanceTS.Adapters.BundesbankTest do
  use FinanceTS.AdapterCase
  alias FinanceTS.Adapters.Bundesbank

  setup do
    Tesla.Mock.mock(fn
      %{
        method: :get,
        url:
          "https://www.bundesbank.de/statistic-rmi/StatisticDownload?tsId=BBEX3.D.XAU.USD.EA.AC.C05&its_csvFormat=en&its_fileFormat=csv&mode=its&its_from=2000"
      } ->
        %Tesla.Env{status: 200, body: File.read!("test/support/adapters/bundesbank/gold_usd.csv")}
    end)

    :ok
  end

  describe "#get_gold_usd" do
    test "returns " do
      {:ok, time_series} = Bundesbank.get_list("GOLD", :d)

      assert %{time_series | data: []} == %TimeSeries{
               symbol: "GOLD",
               currency: "USD",
               source: "Bundesbank",
               size: 89,
               first_ts: 1_577_923_200,
               last_ts: 1_588_809_600,
               latest_price: 1704.05
             }
    end
  end
end
