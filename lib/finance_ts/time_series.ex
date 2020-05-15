defmodule FinanceTS.TimeSeries do
  @moduledoc false

  @enforce_keys [:symbol, :source, :currency]
  defstruct [
    # Example: AAPL
    :symbol,

    # Name of the Exchange or data source.
    # For example NYSE or Deutsche Bundesbank
    :source,

    # The ISO-4217 currency symbol
    :currency,

    # First record, e.g. [3600, 68.7, 70.1, 64.7, 67.9, 4.0e7]
    :first,

    # Last record, e.g. [7200, 68.3, 73.7, 65.8, 73.2, 3.2e7]
    :last,

    # ...
    format: :stream,

    # The amount of datapoints that are available
    size: 0,

    # The data reference, for example the stringified csv
    data: []
  ]
end
