defmodule Wabanex.Trainings.Update do
  alias Ecto.UUID
  alias Wabanex.{Repo, Training}

  def call(id, params) do
    case UUID.cast(id) do
      :error ->
        {:error, "Invalid UUID"}

      {:ok, id} ->
        case Repo.get(Training, id) do
          nil -> {:error, "Training not found"}
          training ->
            %Ecto.Changeset{changes: changes} = Training.changeset(id, params)

            training =
              Repo.preload(training, :exercises)
              |> Ecto.Changeset.change(changes)

            Repo.update(training)
        end
    end
  end
end
