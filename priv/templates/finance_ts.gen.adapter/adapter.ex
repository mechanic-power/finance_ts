defmodule FinanceTS.<%= scoped %>Adapter do
  @moduledoc """
  An Adapter for <%= scoped %>

  Homepage: https://example.com/ TODO
  API Docs: https://example.com/api TODO

  Country: TODO
  """
  @behaviour FinanceTS.Adapter

  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://example.com/api" # TODO

  alias FinanceTS.OHCLV

  # Private functions
  @url "https://example.com/api" # TODO
  defp api_coinlist do
    HTTPoison.get!(@url).body
    |> Poison.decode!
  end
end
