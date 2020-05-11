defmodule FinanceTS.Adapter do
  @moduledoc """
  Specifies the minimal API required from finance adapters.
  """

  @type t :: module

  @callback get_adapter_id() :: atom
end
