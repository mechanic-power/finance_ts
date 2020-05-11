defmodule FinanceTS.BundesbankAdapter do
  @moduledoc """
  An Adapter for Bundesbank

  Homepage: https://www.bundesbank.de
  API Docs: https://www.bundesbank.de/en/statistics/time-series-databases

  Country: Germany
  """
  @behaviour FinanceTS.Adapter
  @source "Bundesbank"

  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://www.bundesbank.de/statistic-rmi/StatisticDownload")

  alias FinanceTS.TimeSeries
  alias FinanceTS.OHLCV

  def get_gold_usd do
    case get("?tsId=BBEX3.D.XAU.USD.EA.AC.C05&its_csvFormat=en&its_fileFormat=csv&mode=its&its_from=2000") do
      {:ok, %{body: raw_csv}} ->
        data =
          raw_csv
          |> String.split("\n")
          |> Enum.map(fn row ->
            row
            |> String.split(",")
            |> cast_row()
          end)
          |> Enum.filter(fn data_point -> valid?(data_point) end)
          |> Enum.map(fn %{ts: ts, c: c} -> %OHLCV{ts: ts, c: c} end)

        {:ok,
         %TimeSeries{
           symbol: "GOLD",
           source: @source,
           currency: "USD",
           data: data
         }}

      {:error, error} ->
        {:error, error}
    end
  end

  # Private functions
  defp valid?(%{ts: nil}), do: false
  defp valid?(%{c: nil}), do: false
  defp valid?(map) when is_map(map), do: true
  defp valid?(_param), do: false

  defp cast_row([date, price_str, _]) do
    %{
      ts: cast_date(date),
      c: cast_price(price_str)
    }
  end

  defp cast_row(_), do: nil

  defp cast_date(date_iso_8601) do
    case DateTime.from_iso8601("#{date_iso_8601}T00:00:00Z") do
      {:ok, datetime, _offset} -> DateTime.to_unix(datetime)
      {:error, :invalid_format} -> nil
    end
  end

  defp cast_price(price_str) do
    case Float.parse(price_str) do
      {price, _} -> price
      :error -> nil
    end
  end
end
