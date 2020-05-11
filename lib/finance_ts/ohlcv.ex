defmodule FinanceTS.OHLCV do
  @enforce_keys [:ts, :c]

  defstruct [
    # Timestamp (without milliseconds)
    :ts,

    # Opening price
    :o,

    # High price
    :h,

    # Low price
    :l,

    # Closing price
    :c,

    # Volume
    :v
  ]
end
