defmodule Wabanex.Users.Get do
  import Ecto.Query

  alias Ecto.UUID
  alias Wabanex.{Repo, Training, User}

  def call(id) do
    case UUID.cast(id) do
      :error ->
        {:error, "Invalid UUID"}

      {:ok, id} ->
        case Repo.get(User, id) do
          nil -> {:error, "User not found"}
          user -> {:ok, load_training(user)}
        end
    end
  end

  defp load_training(user) do
    today = Date.utc_today()

    query =
      from training in Training,
        where: ^today >= training.start_date and ^today <= training.end_date

    Repo.preload(user, trainings: {first(query, :inserted_at), :exercises})
  end
end
