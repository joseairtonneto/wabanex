defmodule Wabanex.Users.Update do
  alias Ecto.UUID
  alias Wabanex.{Repo, User}

  def call(id, params) do
    case UUID.cast(id) do
      :error ->
        {:error, "Invalid UUID"}

      {:ok, id} ->
        case Repo.get(User, id) do
          nil -> {:error, "User not found"}
          user ->
            user = Ecto.Changeset.change(user, params)
            Repo.update(user)
        end
    end
  end
end
