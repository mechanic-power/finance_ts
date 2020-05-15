defmodule FinanceTS do
  alias FinanceTS.OHLCV
  alias FinanceTS.TimeSeries

  @doc """
  iex> FinanceTS.to_list({:ok, [[3600, 68.7, 70.1, 64.7, 67.9, 4.0e7], [7200, 68.3, 73.7, 65.8, 73.2, 3.2e7]], "AAPL", "USD", "NYSE"})
  {:ok, %TimeSeries{
    format: :list,
    data: [%OHLCV{c: 67.9, h: 70.1, l: 64.7, o: 68.7, ts: 3600, v: 4.0e7}, %OHLCV{c: 73.2, h: 73.7, l: 65.8, o: 68.3, ts: 7200, v: 3.2e7}],
    symbol: "AAPL",
    currency: "USD",
    first: %FinanceTS.OHLCV{c: 67.9, h: 70.1, l: 64.7, o: 68.7, ts: 3600, v: 4.0e7},
    last: %FinanceTS.OHLCV{c: 73.2, h: 73.7, l: 65.8, o: 68.3, ts: 7200, v: 3.2e7},
    size: 2,
    source: "NYSE"
  }}
  """
  def to_list({:ok, stream, symbol, currency, source}) do
    list =
      stream
      |> Stream.map(fn [ts, o, h, l, c, v] -> %OHLCV{ts: ts, o: o, h: h, l: l, c: c, v: v} end)
      |> Enum.to_list()

    {:ok,
     %TimeSeries{
       symbol: symbol,
       currency: currency,
       source: source,
       format: :list,
       size: length(list),
       first: List.first(list),
       last: List.last(list),
       data: list
     }}
  end

  def to_csv({:ok, stream, _symbol, _currency, _source}) do
    stream
    |> Enum.map(fn {t, o, h, l, c, v} -> Enum.join([t, o, h, l, c, v], ",") end)
    |> Enum.join("\n")
  end
end
