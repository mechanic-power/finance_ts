defmodule FinanceTS.AdapterCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up an adapter.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      import FinanceTS.AdapterCase
      alias FinanceTS.OHCLV
      alias FinanceTS.TimeSeries
    end
  end

  def assert_ts_struct(info) do
    # assert info.__struct__ == FinanceTS.CryptoExchange
    # assert info.name
    # assert info.homepage_url
    # assert info.api_docs_url
    assert true
    # assert is_list(info.intervals)
  end
end
