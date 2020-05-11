defmodule FinanceTS.Adapters.Finnhub do
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://finnhub.io/api/v1")

  def get_cv_csv(symbol, opts \\ []) do
    case get_raw_ohclv_csv(symbol, opts) do
      {:ok, csv} ->
        trimmed_csv =
          csv
          |> String.replace_leading("t,o,h,l,c,v\n", "")
          |> String.trim_trailing("\n")
          |> filter_cv()

        {:ok, {trimmed_csv, first_ts_from_csv(trimmed_csv), last_ts_from_csv(trimmed_csv)}}

      {:error, error} ->
        {:error, error}
    end
  end

  # Private functions
  defp filter_cv(csv) when is_binary(csv) do
    csv
    |> String.split("\n")
    |> Enum.map(fn line ->
      [ts, _o, _h, _l, c, v] = String.split(line, ",")
      Enum.join([ts, c, v], ",")
    end)
    |> Enum.join("\n")
  end

  defp first_ts_from_csv(csv) do
    csv
    |> String.split("\n")
    |> List.first()
    |> String.split(",")
    |> List.first()
  end

  defp last_ts_from_csv(csv) do
    csv
    |> String.split("\n")
    |> List.last()
    |> String.split(",")
    |> List.first()
  end

  defp get_raw_ohclv_csv(symbol, opts) do
    from = opts[:from] || DateTime.to_unix(~U[1999-01-04 00:00:00Z])
    to = opts[:to] || DateTime.to_unix(DateTime.utc_now())
    resolution = opts[:resolution] || "D"
    url = "/stock/candle?symbol=#{symbol}&resolution=#{resolution}&from=#{from}&to=#{to}&format=csv&token=#{api_key()}"

    case get(url) do
      {:ok, %{body: "t,o,h,l,c,v\n"}} ->
        {:error, "no data"}

      {:ok, %{body: body}} ->
        if String.contains?(body, "no_data") do
          {:error, "no data"}
        else
          {:ok, body}
        end

      {:error, error} ->
        {:error, error}
    end
  end

  defp api_key do
    Application.get_env(:platform, :finnhub)[:api_key]
  end
end