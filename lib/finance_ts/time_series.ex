defmodule FinanceTS.TimeSeries do
  @enforce_keys [:symbol, :source, :currency]
  defstruct [
    # Example: AAPL
    :symbol,

    # Name of the Exchange or data source.
    # For example NYSE or Deutsche Bundesbank
    :source,

    # The ISO-4217 currency symbol
    :currency,

    # First timestamp (without milliseconds) of a TimeSeries
    :first_ts,

    # Last timestamp (without milliseconds) of a TimeSeries
    :last_ts,

    # Latest price
    :latest_price,

    # ...
    format: "list",

    # The amount of datapoints that are available
    size: 0,

    # The data reference, for example the stringified csv
    data: []
  ]
end
