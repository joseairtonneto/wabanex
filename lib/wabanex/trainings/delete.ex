defmodule Wabanex.Trainings.Delete do
  alias Ecto.UUID
  alias Wabanex.{Repo, Training}

  def call(id) do
    case UUID.cast(id) do
      :error ->
        {:error, "Invalid UUID"}

      {:ok, id} ->
        case Repo.get(Training, id) do
          nil -> {:error, "Training not found"}
          training ->
            training = Repo.preload(training, :exercises)
            
            Enum.map(training.exercises, fn exercise -> Repo.delete(exercise) end)

            Repo.delete(training)
        end
    end
  end
end
