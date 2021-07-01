defmodule Wabanex.Trainings.Delete do
  alias Ecto.UUID
  alias Wabanex.{Repo, Training}

  def call(id) do
    case UUID.cast(id) do
      :error ->
        {:error, "Invalid UUID"}

      {:ok, id} ->
        case Repo.get(Training, id) do
          nil -> {:error, "User not found"}
          training -> Repo.delete(training)
        end
    end
  end
end
