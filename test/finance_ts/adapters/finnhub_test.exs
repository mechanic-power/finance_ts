defmodule FinanceTS.Adapters.FinnhubTest do
  use FinanceTS.AdapterCase

  alias FinanceTS.Adapters.Finnhub

  setup do
    Tesla.Mock.mock(fn
      %{method: :get, url: "https://finnhub.io/api/v1/stock/candle?symbol=aapl&resolution=D&from=915408000&to=1588344980&format=csv&token="} ->
        %Tesla.Env{status: 200, body: File.read!("test/support/adapters/finnhub/aapl.csv")}

      %{method: :get, url: "https://finnhub.io/api/v1/stock/candle?symbol=empty&resolution=D&from=915408000&to=1588344980&format=csv&token="} ->
        %Tesla.Env{status: 200, body: File.read!("test/support/adapters/finnhub/empty.csv")}
    end)

    :ok
  end

  describe "#get_cv_csv" do
    test "test fully working chart" do
      result = Finnhub.get_cv_csv("aapl", to: 1_588_344_980)
      assert {:ok, {csv, first_ts, last_ts}} = result

      assert csv |> String.split("\n") == [
               "1586439000,267.99,4.05291e+07",
               "1586784600,273.25,3.27557e+07",
               "1586871000,287.05,4.87487e+07",
               "1586957400,284.43,3.27886e+07",
               "1587043800,286.69,3.92813e+07",
               "1587130200,282.8,5.38125e+07",
               "1587389400,276.93,3.25038e+07",
               "1587475800,268.37,4.52479e+07",
               "1587562200,276.1,2.92643e+07",
               "1587648600,275.03,3.12036e+07",
               "1587735000,282.97,3.16272e+07",
               "1587994200,283.17,2.92364e+07",
               "1588080600,278.58,2.385367e+07"
             ]

      assert first_ts == "1586439000"
      assert last_ts == "1588080600"
    end

    test "test empty chart" do
      result = Finnhub.get_cv_csv("empty", to: 1_588_344_980)
      assert {:error, "no data"} = result
    end
  end
end
