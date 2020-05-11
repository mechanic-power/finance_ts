defmodule FinanceTS.Schema.OHCLV do
  use Ecto.Schema
  import Ecto.Changeset

  schema "" do
    field(:ts, :integer)
    field(:o, :float)
    field(:h, :float)
    field(:c, :float)
    field(:l, :float)
    field(:v, :float)
  end

  @fields ~w(ts o h c l v)a
  def changeset(meta, attrs, _) do
    meta
    |> cast(attrs, @fields)
    |> validate_required(~w(ts)a)
  end
end
