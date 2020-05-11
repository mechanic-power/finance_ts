defmodule FinanceTS.<%= scoped %>Adapter do
  @moduledoc """
  An Adapter for <%= scoped %>

  Homepage: https://example.com/ TODO
  API Docs: https://example.com/api TODO

  Country: TODO
  """
  @behaviour FinanceTS.Adapter

  alias FinanceTS.OHCLV

  # ...

  # Private functions
  @url "https://example.com/api" # TODO
  defp api_coinlist do
    HTTPoison.get!(@url).body
    |> Poison.decode!
  end
end
