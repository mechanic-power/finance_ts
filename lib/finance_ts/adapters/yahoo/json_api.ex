defmodule FinanceTS.Adapters.Yahoo.JsonApi do
  use Tesla

  alias FinanceTS.OHCLV
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
  defp cast_finance_meta(%{
         "indicators" => %{"quote" => quotes},
         "meta" => meta,
         "timestamp" => timestamps
       }) do
    candles = cast_candles(timestamps, quotes)

    %OHCLV{ts: first_ts} = List.first(candles)
    %OHCLV{ts: last_ts, c: latest_price} = List.last(candles)

    {:ok,
     %TimeSeries{
       symbol: meta["symbol"],
       currency: String.upcase(meta["currency"]),
       source: meta["exchangeName"],
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

  defp cast_candles(timestamps, [quotes]) do
    do_cast_candles(timestamps, quotes["open"], quotes["high"], quotes["close"], quotes["low"], quotes["volume"], [])
  end

  defp do_cast_candles([ts | list_ts], [o | list_o], [h | list_h], [c | list_c], [l | list_l], [v | list_v], result) do
    ohclv = %OHCLV{ts: ts, o: o, h: h, c: c, l: l, v: v}
    do_cast_candles(list_ts, list_o, list_h, list_c, list_l, list_v, [ohclv | result])
  end

  defp do_cast_candles([], [], [], [], [], [], result) do
    result |> Enum.reverse()
  end
end
