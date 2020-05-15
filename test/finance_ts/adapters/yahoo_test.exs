defmodule FinanceTS.Adapters.YahooTest do
  use FinanceTS.AdapterCase

  alias FinanceTS.Adapters.Yahoo

  setup do
    Tesla.Mock.mock(fn
      %{method: :get, url: "https://query1.finance.yahoo.com/v8/finance/chart/ncm.ax?range=7d&interval=1h&events=history,div,splits"} ->
        %Tesla.Env{status: 200, body: File.read!("test/support/adapters/yahoo/ncm.ax_7d.json") |> Jason.decode!()}

      %{method: :get, url: "https://query1.finance.yahoo.com/v8/finance/chart/agldf?range=7d&interval=1h&events=history,div,splits"} ->
        %Tesla.Env{status: 200, body: File.read!("test/support/adapters/yahoo/agldf_7d_no_candles.json") |> Jason.decode!()}
    end)

    :ok
  end

  describe "#get_stream" do
    test "test fully working chart" do
      {:ok, stream, symbol, currency, source} = Yahoo.get_stream("ncm.ax", :h)
      list = Enum.to_list(stream)

      assert length(list) == 42
      assert [1_586_217_600, 26.709999084472656, 27.170000076293945, 26.40999984741211, 26.559999465942383, 0] = List.first(list)
      assert [1_587_099_600, 28.31999969482422, 28.610000610351563, 28.260000228881836, 28.56999969482422, 450_952] = List.last(list)

      assert symbol == "NCM.AX"
      assert currency == "AUD"
      assert source == "ASX"
    end

    test "test chart with no data" do
      {:ok, stream, symbol, currency, source} = Yahoo.get_stream("agldf", :h)
      list = Enum.to_list(stream)

      assert list == []
      assert symbol == "AGLDF"
      assert currency == "USD"
      assert source == "PNK"
    end
  end
end
