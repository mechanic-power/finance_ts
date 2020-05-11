defmodule FinanceTS.OHCLV do
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

    # Closeing price
    :c,

    # Volume
    :v
  ]
end
