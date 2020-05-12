defmodule FinanceTS.Adapter.Conversion do
  @moduledoc """
  This module contains functions for time conversions. These are use to convert
  every kind of date to the date format of the adapter. Most likely used to convert
  the 'from' and 'to' options.
  """

  @doc """
  Convert different types of date/datetime into a timestamp

  iex> Conversion.to_ts!(315_532_800)
  315_532_800

  iex> Conversion.to_ts!(~U[1980-01-01T00:00:00Z])
  315_532_800

  iex> Conversion.to_ts!(~D[1980-01-01])
  315_532_800

  iex> Conversion.to_ts!("1980-01-01")
  315_532_800

  iex> Conversion.to_ts!("19800101")
  315_532_800
  """
  def to_ts!(ts) when is_integer(ts), do: ts
  def to_ts!(%DateTime{} = datetime), do: DateTime.to_unix(datetime)
  def to_ts!(%Date{} = date), do: to_ts!(Date.to_string(date))

  def to_ts!(str) when byte_size(str) == 10 do
    {:ok, datetime, 0} = DateTime.from_iso8601("#{str}T00:00:00Z")
    DateTime.to_unix(datetime)
  end

  def to_ts!(str) when byte_size(str) == 8 do
    [y1, y2, m, d] = String.split(str, ~r/(\d\d)/, include_captures: true, trim: true)
    {:ok, datetime, 0} = DateTime.from_iso8601("#{y1}#{y2}-#{m}-#{d}T00:00:00Z")
    DateTime.to_unix(datetime)
  end

  @doc """
  Convert different types of date/datetime into a timestamp

  iex> Conversion.to_iso8601_date!("1980-01-01")
  "1980-01-01"

  iex> Conversion.to_iso8601_date!("19800101")
  "1980-01-01"

  iex> Conversion.to_iso8601_date!(~D[1980-01-01])
  "1980-01-01"

  iex> Conversion.to_iso8601_date!(~U[1980-01-01T00:00:00Z])
  "1980-01-01"
  """
  def to_iso8601_date!(str) when byte_size(str) == 10, do: str
  def to_iso8601_date!(%Date{} = date), do: Date.to_string(date)
  def to_iso8601_date!(%DateTime{} = datetime), do: Date.to_string(DateTime.to_date(datetime))

  def to_iso8601_date!(str) when byte_size(str) == 8 do
    [y1, y2, m, d] = String.split(str, ~r/(\d\d)/, include_captures: true, trim: true)
    "#{y1}#{y2}-#{m}-#{d}"
  end
end
