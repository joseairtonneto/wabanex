defmodule Wabanex.Repo.Migrations.AlterUsersTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:heigth, :float)
      add(:weigth, :float)
      add(:fat_index, :float)
      add(:muscle_index, :float)
    end
  end
end
