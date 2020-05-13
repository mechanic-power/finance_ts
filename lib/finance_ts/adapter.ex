defmodule FinanceTS.Adapter do
  @moduledoc """
  Specifies the minimal API required from finance adapters.
  """
  @callback get_stream(String.t(), atom() | {atom(), integer()}, keyword()) :: any()
end
