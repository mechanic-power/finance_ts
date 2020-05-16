defmodule FinanceTS.Adapters.Finnhub do
  @moduledoc """
  An Adapter for Finnhub.io

  Homepage: https://finnhub.io/
  API Docs: https://finnhub.io/docs/api
  """
  use Tesla
  plug(Tesla.Middleware.BaseUrl, "https://finnhub.io/api/v1")

  @behaviour FinanceTS.Adapter

  @supported_resolutions [:minute, {:minute, 5}, {:minute, 15}, {:minute, 30}, :hour, :day, :week, :month]

  def get_stream(symbol, resolution, opts \\ []) do
    check_resolution(resolution)

    case get_raw_ohclv_csv(symbol, resolution, opts) do
      {:ok, csv} ->
        stream =
          csv
          |> String.replace_leading("t,o,h,l,c,v\n", "")
          |> String.trim_trailing("\n")
          |> String.split("\n")
          |> Stream.map(fn line ->
            [t, o, h, l, c, v] = String.split(line, ",")
            [cast_int(t), cast_float(o), cast_float(h), cast_float(l), cast_float(c), cast_float(v)]
          end)

        {:ok, stream, symbol, "USD", "Unknown"}

      {:error, error} ->
        {:error, error}
    end
  end

  # Private functions
  defp cast_int(price_str) do
    case Integer.parse(price_str) do
      {price, _} -> price
      :error -> nil
    end
  end

  defp cast_float(price_str) do
    case Float.parse(price_str) do
      {price, _} -> price
      :error -> nil
    end
  end

  defp get_raw_ohclv_csv(symbol, resolution, opts) do
    from = opts[:from] || DateTime.to_unix(~U[1999-01-04 00:00:00Z])
    to = opts[:to] || DateTime.to_unix(DateTime.utc_now())
    resolution_param = convert_resolution_to_parameter(resolution)
    url = "/stock/candle?symbol=#{symbol}&resolution=#{resolution_param}&from=#{from}&to=#{to}&format=csv&token=#{api_key()}"

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

  defp convert_resolution_to_parameter(:minute), do: "1"
  defp convert_resolution_to_parameter({:minute, 5}), do: "5"
  defp convert_resolution_to_parameter({:minute, 15}), do: "15"
  defp convert_resolution_to_parameter({:minute, 30}), do: "30"
  defp convert_resolution_to_parameter(:hour), do: "60"
  defp convert_resolution_to_parameter(:day), do: "D"
  defp convert_resolution_to_parameter(:week), do: "W"
  defp convert_resolution_to_parameter(:month), do: "M"

  defp check_resolution(r) when r in @supported_resolutions, do: nil
  defp check_resolution(r), do: raise("Resolution #{inspect(r)} not supported. Use one of the following: #{inspect(@supported_resolutions)}.")

  defp api_key do
    Application.get_env(:finance_ts, :finnhub)[:api_key]
  end
end
