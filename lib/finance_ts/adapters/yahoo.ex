defmodule FinanceTS.Adapters.Yahoo do
  @moduledoc """
  An Adapter for Yahoo Finance

  Homepage: https://finance.yahoo.com/
  API Docs: (The api is not officially documented)
  """
  @behaviour FinanceTS.Adapter

  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://query1.finance.yahoo.com/v8/finance")
  plug(Tesla.Middleware.JSON)

  def get_stream(stock_ticker, _resolution, opts \\ []) do
    range = opts[:range] || "7d"
    interval = opts[:interval] || "1h"

    case get("/chart/#{stock_ticker}?range=#{range}&interval=#{interval}&events=history,div,splits") do
      {:ok, %{body: %{"chart" => %{"error" => nil, "result" => [result]}}}} ->
        cast_finance_meta(result)

      {:ok, %{body: %{"chart" => %{"error" => error}}}} ->
        {:error, error}

      {:error, error} ->
        {:error, error}
    end
  end

  # Private functions
  defp cast_finance_meta(%{"indicators" => %{"quote" => [quotes]}, "meta" => meta, "timestamp" => timestamps}) do
    stream =
      [timestamps, quotes["open"], quotes["high"], quotes["low"], quotes["close"], quotes["volume"]]
      |> Stream.zip()

    {:ok, stream, meta["symbol"], meta["currency"], meta["exchangeName"]}
  end

  defp cast_finance_meta(%{"meta" => meta}) do
    {:ok, [], meta["symbol"], meta["currency"], meta["exchangeName"]}
  end
end
