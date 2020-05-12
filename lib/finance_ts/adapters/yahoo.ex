defmodule FinanceTS.Adapters.Yahoo do
  @behaviour FinanceTS.Adapter

  def get_adapter_id, do: :yahoo

  use Tesla

  alias FinanceTS.OHLCV
  alias FinanceTS.TimeSeries

  plug(Tesla.Middleware.BaseUrl, "https://query1.finance.yahoo.com/v8/finance")
  plug(Tesla.Middleware.JSON)

  def chart(stock_ticker, opts \\ []) do
    range = opts[:range] || "7d"
    interval = opts[:interval] || "1h"

    case get("/chart/#{stock_ticker}?range=#{range}&interval=#{interval}&events=history,div,splits") do
      {:ok, %{body: %{"chart" => %{"error" => nil, "result" => [result]}}}} ->
        cast_finance_meta(result)

      {:ok, %{body: %{"chart" => %{"error" => error}}}} ->
        {:error, error}

      {:error, error} ->
        {:error, error}
    end
  end

  # Private functions
  defp cast_finance_meta(%{"indicators" => %{"quote" => [quotes]}, "meta" => meta, "timestamp" => timestamps}) do
    candles =
      [timestamps, quotes["open"], quotes["high"], quotes["low"], quotes["close"], quotes["volume"]]
      |> Stream.zip()
      |> Stream.map(fn {ts, o, h, l, c, v} -> %OHLCV{ts: ts, o: o, h: h, l: l, c: c, v: v} end)
      |> Enum.to_list()

    %OHLCV{ts: first_ts} = List.first(candles)
    %OHLCV{ts: last_ts, c: latest_price} = List.last(candles)

    {:ok,
     %TimeSeries{
       symbol: meta["symbol"],
       currency: String.upcase(meta["currency"]),
       source: meta["exchangeName"],
       size: length(candles),
       first_ts: first_ts,
       last_ts: last_ts,
       latest_price: latest_price,
       data: candles
     }}
  end

  defp cast_finance_meta(%{"meta" => meta}) do
    {:ok,
     %TimeSeries{
       symbol: meta["symbol"],
       currency: meta["currency"],
       source: meta["exchangeName"],
       data: []
     }}
  end
end
