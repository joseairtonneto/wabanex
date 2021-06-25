defmodule Wabanex.Users.Get do
  alias Ecto.UUID
  alias Wabanex.{Repo, User}

  def call(id) do
    case UUID.cast(id) do
      :error ->
        {:error, "Invalid UUID"}

      {:ok, id} ->
        case Repo.get(User, id) do
          nil -> {:error, "User not found"}
          user -> {:ok, user}
        end
    end
  end
end
