defmodule FinanceTS.Schema.TimeSeries do
  defstruct [
    :symbol, :exchange, :currency, :first_ts, :last_ts, :latest_price,
    format: "list", data: []
  ]
end
