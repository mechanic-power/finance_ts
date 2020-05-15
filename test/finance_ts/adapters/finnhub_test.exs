defmodule FinanceTS.Adapters.FinnhubTest do
  use FinanceTS.AdapterCase

  alias FinanceTS.Adapters.Finnhub

  setup do
    Tesla.Mock.mock(fn
      %{method: :get, url: "https://finnhub.io/api/v1/stock/candle?symbol=aapl&resolution=D&from=915408000&to=1588344980&format=csv&token=secret"} ->
        %Tesla.Env{status: 200, body: File.read!("test/support/adapters/finnhub/aapl.csv")}

      %{method: :get, url: "https://finnhub.io/api/v1/stock/candle?symbol=empty&resolution=D&from=915408000&to=1588344980&format=csv&token=secret"} ->
        %Tesla.Env{status: 200, body: File.read!("test/support/adapters/finnhub/empty.csv")}
    end)

    :ok
  end

  describe "#get_stream" do
    test "test fully working chart" do
      {:ok, stream, "aapl", "USD", "Unknown"} = Finnhub.get_stream("aapl", :d, to: 1_588_344_980)
      list = Enum.to_list(stream)

      assert list == [
               [1_586_439_000, 268.7, 270.07, 264.7, 267.99, 4.05291e7],
               [1_586_784_600, 268.31, 273.7, 265.83, 273.25, 3.27557e7],
               [1_586_871_000, 280.0, 288.25, 278.05, 287.05, 4.87487e7],
               [1_586_957_400, 282.4, 286.33, 280.63, 284.43, 3.27886e7],
               [1_587_043_800, 287.38, 288.2, 282.35, 286.69, 3.92813e7],
               [1_587_130_200, 284.69, 286.95, 276.86, 282.8, 5.38125e7],
               [1_587_389_400, 277.95, 281.68, 276.85, 276.93, 3.25038e7],
               [1_587_475_800, 276.28, 277.25, 265.43, 268.37, 4.52479e7],
               [1_587_562_200, 273.61, 277.9, 272.2, 276.1, 2.92643e7],
               [1_587_648_600, 275.87, 281.75, 274.87, 275.03, 3.12036e7],
               [1_587_735_000, 277.2, 283.01, 277.0, 282.97, 3.16272e7],
               [1_587_994_200, 281.8, 284.54, 279.95, 283.17, 2.92364e7],
               [1_588_080_600, 285.08, 285.83, 278.45, 278.58, 23_853_670.0]
             ]
    end

    test "test empty chart" do
      result = Finnhub.get_stream("empty", :d, to: 1_588_344_980)
      assert {:error, "no data"} = result
    end

    test "test invalid resolution" do
      assert_raise RuntimeError, ~r/^Resolution :unknown not supported/, fn ->
        Finnhub.get_stream("empty", :unknown)
      end
    end
  end
end
