defmodule FinanceTS.Schema.TimeSeries do
  use Ecto.Schema
  import Ecto.Changeset

  alias FinanceTS.Schema.OHCLV

  schema "" do
    field(:symbol, :string)
    field(:format, :string, default: "list")
    field(:exchange, :string)
    field(:currency, :string)
    field(:first_ts, :integer)
    field(:last_ts, :integer)
    field(:latest_price, :float)

    embeds_many(:data, OHCLV)
  end

  @fields ~w(symbol exchange currency)a
  def changeset(meta, attrs, type) when type in [:create, :update] do
    meta
    |> cast(attrs, @fields)
    |> validate_required(~w(symbol)a)
  end
end
