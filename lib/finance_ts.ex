defmodule FinanceTS do
  alias FinanceTS.OHLCV
  alias FinanceTS.TimeSeries

  @doc """
  iex> FinanceTS.to_list({:ok, [{3600, 68.7, 70.1, 64.7, 67.9, 4.0e7}, {7200, 68.3, 73.7, 65.8, 73.2, 3.2e7}], "AAPL", "USD", "..."})
  {:ok, %TimeSeries{
    format: :list,
    data: [%OHLCV{c: 67.9, h: 70.1, l: 64.7, o: 68.7, ts: 3600, v: 4.0e7}, %OHLCV{c: 73.2, h: 73.7, l: 65.8, o: 68.3, ts: 7200, v: 3.2e7}],
    symbol: "AAPL",
    currency: "USD",
    first_ts: 3600,
    last_ts: 7200,
    latest_price: 73.2,
    size: 2,
    source: "..."
  }}
  """
  def to_list({:ok, stream, symbol, currency, source}) do
    list =
      stream
      |> Stream.map(fn {ts, o, h, l, c, v} -> %OHLCV{ts: ts, o: o, h: h, l: l, c: c, v: v} end)
      |> Enum.to_list()

    %OHLCV{ts: first_ts} = List.first(list)
    %OHLCV{ts: last_ts, c: latest_price} = List.last(list)

    {:ok,
     %TimeSeries{
       symbol: symbol,
       currency: currency,
       source: source,
       format: :list,
       size: length(list),
       first_ts: first_ts,
       last_ts: last_ts,
       latest_price: latest_price,
       data: list
     }}
  end

  def to_csv({:ok, stream, _symbol, _currency, _source}) do
    stream
    |> Enum.map(fn {t, o, h, l, c, v} -> Enum.join([t, o, h, l, c, v], ",") end)
    |> Enum.join("\n")
  end
end
