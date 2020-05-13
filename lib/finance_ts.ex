defmodule FinanceTS do
  alias FinanceTS.OHLCV
  alias FinanceTS.TimeSeries

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
       size: length(list),
       first_ts: first_ts,
       last_ts: last_ts,
       latest_price: latest_price,
       data: list
     }}
  end

  def to_csv({:ok, stream, symbol, currency, source}) do
    stream
    |> Enum.map(fn {t, o, h, l, c, v} -> Enum.join([t, o, h, l, c, v], ",") end)
    |> Enum.join("\n")
  end
end
