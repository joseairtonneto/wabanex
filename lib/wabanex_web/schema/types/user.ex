defmodule WabanexWeb.Schema.Types.User do
  use Absinthe.Schema.Notation

  @desc "Logic user representation"
  object :user do
    field(:id, non_null(:uuid4))
    field(:name, non_null(:string))
    field(:email, non_null(:string))
    field(:trainings, list_of(:training))
  end

  input_object :create_user_input do
    field(:name, non_null(:string))
    field(:email, non_null(:string))
    field(:password, non_null(:string))
    field(:heigth, non_null (:float))
    field(:weigth, non_null(:float))
    field(:fat_index, non_null(:float))
    field(:muscle_index, non_null(:float))
  end

  input_object :update_user_input do
    field(:name, :string)
    field(:email, :string)
    field(:password, :string)
    field(:heigth, :float)
    field(:weigth, :float)
    field(:fat_index, :float)
    field(:muscle_index, :float)
  end
end
