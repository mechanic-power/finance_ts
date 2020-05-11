defmodule FinanceTS.Adapters.Yahoo.JsonApiTest do
  use Platform.DataCase

  alias FinanceTS.Adapters.Yahoo.JsonApi
  alias FinanceTS.Schema.OHCLV
  alias FinanceTS.Schema.TimeSeries

  setup do
    Tesla.Mock.mock(fn
      %{
        method: :get,
        url:
          "https://query1.finance.yahoo.com/v8/finance/chart/ncm.ax?range=7d&interval=1h&events=history,div,splits"
      } ->
        %Tesla.Env{
          status: 200,
          body: File.read!("test/support/yahoo_finance/ncm.ax_7d.json") |> Jason.decode!()
        }

      %{
        method: :get,
        url:
          "https://query1.finance.yahoo.com/v8/finance/chart/agldf?range=7d&interval=1h&events=history,div,splits"
      } ->
        %Tesla.Env{
          status: 200,
          body:
            File.read!("test/support/yahoo_finance/agldf_7d_no_candles.json") |> Jason.decode!()
        }
    end)

    :ok
  end

  describe "#chart" do
    test "test fully working chart" do
      {:ok, time_series} = JsonApi.chart("ncm.ax")

      assert %{time_series | data: []} == %TimeSeries{
               symbol: "NCM.AX",
               currency: "AUD",
               exchange: "ASX",
               first_ts: 1_586_217_600,
               last_ts: 1_587_099_600,
               latest_price: 28.56999969482422
             }

      assert length(time_series.data) == 42

      assert List.first(time_series.data) == %OHCLV{
               c: 26.559999465942383,
               h: 27.170000076293945,
               id: nil,
               l: 26.40999984741211,
               o: 26.709999084472656,
               ts: 1_586_217_600,
               v: 0
             }

      assert List.last(time_series.data) == %OHCLV{
               c: 28.56999969482422,
               h: 28.610000610351563,
               id: nil,
               l: 28.260000228881836,
               o: 28.31999969482422,
               ts: 1_587_099_600,
               v: 450_952
             }
    end

    test "test chart with no data" do
      # assert JsonApi.do_cast_candles([1,2,3,4], [1,2,3,4], []) == [1,2,3]

      {:ok, time_series} = JsonApi.chart("agldf")

      assert time_series == %TimeSeries{
               symbol: "AGLDF",
               currency: "USD",
               exchange: "PNK",
               data: []
             }
    end
  end
end
