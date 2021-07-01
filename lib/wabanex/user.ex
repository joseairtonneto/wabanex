defmodule Wabanex.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Wabanex.Training

  @primary_key {:id, :binary_id, autogenerate: true}

  @fields [:email, :password, :name, :heigth, :weigth, :fat_index, :muscle_index]

  schema "users" do
    field(:email, :string)
    field(:name, :string)
    field(:password, :string)
    field(:heigth, :float)
    field(:weigth, :float)
    field(:fat_index, :float)
    field(:muscle_index, :float)

    has_many(:trainings, Training)

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_length(:password, min: 6)
    |> validate_length(:name, min: 2)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint([:email])
  end
end
