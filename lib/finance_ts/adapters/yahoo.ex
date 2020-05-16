defmodule FinanceTS.Adapters.Yahoo do
  @moduledoc """
  An Adapter for Yahoo Finance

  Homepage: https://finance.yahoo.com/
  API Docs: (The api is not officially documented)
  """
  @behaviour FinanceTS.Adapter

  @supported_resolutions [
    :minute,
    {:minute, 2},
    {:minute, 5},
    {:minute, 15},
    {:minute, 30},
    {:minute, 90},
    :hour,
    :day,
    {:day, 5},
    :week,
    :month,
    {:month, 3}
  ]
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://query1.finance.yahoo.com/v8/finance")
  plug(Tesla.Middleware.JSON)

  def get_stream(stock_ticker, resolution, _opts \\ []) do
    check_resolution(resolution)
    interval_param = convert_resolution_to_parameter(resolution)

    range =
      case resolution do
        :minute -> "7d"
        {:minute, _} -> "1mo"
        :hour -> "1mo"
        :day -> "10y"
        :week -> "10y"
        _ -> "max"
      end

    case get("/chart/#{stock_ticker}?range=#{range}&interval=#{interval_param}&events=history,div,splits") do
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
    %{"symbol" => symbol, "currency" => currency, "exchangeName" => exchange_name, "gmtoffset" => gmtoffset} = meta

    stream =
      [timestamps, quotes["open"], quotes["high"], quotes["low"], quotes["close"], quotes["volume"]]
      |> Stream.zip()
      |> Stream.map(fn {t, o, h, l, c, v} -> [t + gmtoffset, o, h, l, c, v] end)

    {:ok, stream, symbol, currency, exchange_name}
  end

  defp cast_finance_meta(%{"meta" => %{"symbol" => symbol, "currency" => currency, "exchangeName" => exchange_name}}) do
    {:ok, [], symbol, currency, exchange_name}
  end

  defp convert_resolution_to_parameter(:minute), do: "1m"
  defp convert_resolution_to_parameter({:minute, 2}), do: "2m"
  defp convert_resolution_to_parameter({:minute, 5}), do: "5m"
  defp convert_resolution_to_parameter({:minute, 15}), do: "15m"
  defp convert_resolution_to_parameter({:minute, 30}), do: "30m"
  defp convert_resolution_to_parameter({:minute, 90}), do: "30m"
  defp convert_resolution_to_parameter(:hour), do: "1h"
  defp convert_resolution_to_parameter(:day), do: "1d"
  defp convert_resolution_to_parameter(:week), do: "1wk"
  defp convert_resolution_to_parameter(:month), do: "1mo"
  defp convert_resolution_to_parameter({:month, 3}), do: "3mo"

  defp check_resolution(r) when r in @supported_resolutions, do: nil
  defp check_resolution(r), do: raise("Resolution #{inspect(r)} not supported. Use one of the following: #{inspect(@supported_resolutions)}.")
end
