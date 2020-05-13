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

  describe "#get_stream" do
    test "returns 123" do
      {:ok, stream, "GOLD", "USD", "Bundesbank"} = Bundesbank.get_stream("GOLD", :d)
      list = Enum.to_list(stream)

      assert list == [
               {1_577_923_200, nil, nil, nil, 1527.1, nil},
               {1_578_009_600, nil, nil, nil, 1548.75, nil},
               {1_578_268_800, nil, nil, nil, 1573.1, nil},
               {1_578_355_200, nil, nil, nil, 1567.85, nil},
               {1_578_441_600, nil, nil, nil, 1571.95, nil},
               {1_578_528_000, nil, nil, nil, 1550.75, nil},
               {1_578_614_400, nil, nil, nil, 1553.6, nil},
               {1_578_873_600, nil, nil, nil, 1549.9, nil}
             ]
    end
  end
end
