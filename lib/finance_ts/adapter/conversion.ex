defmodule FinanceTS.Adapter.Conversion do
  def to_ts!(ts) when is_integer(ts), do: ts
  def to_ts!(%DateTime{} = datetime), do: DateTime.to_unix(datetime)
  def to_ts!(%Date{} = date), do: to_ts!(Date.to_string(date))

  def to_ts!(str) when byte_size(str) == 10 do
    {:ok, datetime, 0} = DateTime.from_iso8601("#{str}T00:00:00Z")
    IO.inspect(byte_size(str))
    DateTime.to_unix(datetime)
  end

  def to_ts!(str) when byte_size(str) == 8 do
    [y1, y2, m, d] = String.split(str, ~r/(\d\d)/, include_captures: true, trim: true)
    {:ok, datetime, 0} = DateTime.from_iso8601("#{y1}#{y2}-#{m}-#{d}T00:00:00Z")
    DateTime.to_unix(datetime)
  end
end
