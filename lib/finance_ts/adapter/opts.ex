defmodule FinanceTS.Adapter.Opts do
  @moduledoc false

  defstruct [
    :from,
    :to,
    fields: [:o, :h, :l, :c, :v],
    csv_header: false,
    pass_through: []
  ]
end
