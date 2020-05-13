defmodule FinanceTS.Adapters.Bundesbank do
  @moduledoc """
  An Adapter for Bundesbank

  Homepage: https://www.bundesbank.de/dynamic/action/en/statistics/time-series-databases/time-series-databases/759784/759784?listId=www_s331_b01015_3
  API Docs: https://www.bundesbank.de/en/statistics/time-series-databases/-/help-on-the-time-series-databases-750894
  """
  use Tesla
  plug(Tesla.Middleware.BaseUrl, "https://www.bundesbank.de/statistic-rmi")

  @behaviour FinanceTS.Adapter

  def get_stream("GOLD", :d, _opts \\ []) do
    case get("/StatisticDownload?tsId=BBEX3.D.XAU.USD.EA.AC.C05&its_csvFormat=en&its_fileFormat=csv&mode=its&its_from=2000") do
      {:ok, %{body: raw_csv}} ->
        stream =
          raw_csv
          |> String.split("\n")
          |> Stream.map(fn row ->
            row
            |> String.split(",")
            |> cast_row()
          end)
          |> Stream.filter(fn data_point -> valid?(data_point) end)

        {:ok, stream, "GOLD", "USD", "Bundesbank"}

      {:error, error} ->
        {:error, error}
    end
  end

  # Private functions
  defp valid?({t, _, _, _, c, _}) when not is_nil(t) and not is_nil(c), do: true
  defp valid?(_param), do: false

  defp cast_row([date, price_str, _]) do
    {cast_date(date), nil, nil, nil, cast_price(price_str), nil}
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
