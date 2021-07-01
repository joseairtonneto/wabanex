defmodule Wabanex.TrainingTest do
  use Wabanex.DataCase, async: true

  alias Wabanex.{Training, User}
  alias Wabanex.Users.Create, as: UserCreate

  describe "changeset/1" do
    test "when all params are valid, returns a valid changeset" do
      user = %{
        name: "Airton",
        email: "airton@cena.com",
        password: "123456",
        heigth: 1.75,
        weigth: 80.0,
        fat_index: 0.60,
        muscle_index: 0.40
      }

      {:ok, %User{id: user_id}} = UserCreate.call(user)

      params = %{
        start_date: "2021-06-11",
        end_date: "2021-07-11",
        user_id: "#{user_id}",
        exercises: [
          %{
            name: "Triceps",
            youtube_video_url: "www.test.com",
            protocol_description: "regular",
            repetitions: "3x15"
          }
        ]
      }

      response = Training.changeset(params)

      assert %Ecto.Changeset{
        valid?: true,
        changes: %{
          end_date: ~D[2021-07-11],
          exercises: [
            %Ecto.Changeset{
              valid?: true,
              changes: %{
                name: "Triceps",
                protocol_description: "regular",
                repetitions: "3x15",
                youtube_video_url: "www.test.com"
              },
              errors: []
            }
          ],
          start_date: ~D[2021-06-11],
        },
        errors: []
      } = response
    end

    test "when misses a field in params, returns an error" do
      user = %{
        name: "Airton",
        email: "airton@cena.com",
        password: "123456",
        heigth: 1.75,
        weigth: 80.0,
        fat_index: 0.60,
        muscle_index: 0.40
      }

      {:ok, %User{id: user_id}} = UserCreate.call(user)

      params = %{
        start_date: "2021-06-11",
        user_id: "#{user_id}",
        exercises: []
      }

      response = Training.changeset(params)

      expected_response = %{end_date: ["can't be blank"]}

      assert errors_on(response) == expected_response
    end
  end
end
