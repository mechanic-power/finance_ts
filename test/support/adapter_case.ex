defmodule FinanceTS.AdapterCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up an adapter.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      import FinanceTS.AdapterCase
      alias FinanceTS.OHLCV
      alias FinanceTS.TimeSeries
    end
  end
end
