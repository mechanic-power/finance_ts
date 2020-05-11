defmodule FinanceTS.Schema.TimeSeries do
  @enforce_keys [:symbol, :source, :currency]
  defstruct [
    # Example: AAPL
    :symbol,

    # The name of the source. For example: Yahoo
    :source,

    # The ISO-4217 currency symbol
    :currency,

    # The first timestamp (without milliseconds) of a TimeSeries
    :first_ts,

    # The last timestamp (without milliseconds) of a TimeSeries
    :last_ts,

    # The latest price
    :latest_price,

    format: "list",

    # The raw data, for example the stringified csv
    data: []
  ]
end
