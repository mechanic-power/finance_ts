defmodule FinanceTS.Adapter do
  @moduledoc """
  Specifies the minimal API required from finance adapters.
  """

  @type t :: module

  @callback get_adapter_id() :: atom

  @callback get_list(String.t(), atom() | {atom(), integer()}, keyword()) :: any()

  @callback get_csv(String.t(), atom() | {atom(), integer()}, keyword()) :: any()
end
