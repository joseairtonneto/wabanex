defmodule Wabanex.ExerciseTest do
  use Wabanex.DataCase, async: true

  alias Wabanex.Exercise

  describe "changeset/1" do
    test "when all params are valid, returns a valid changeset" do
      params = %{
        name: "Triceps",
        youtube_video_url: "www.test.com",
        protocol_description: "regular",
        repetitions: "3x15"
      }

      response = Exercise.changeset(%Exercise{}, params)

      assert %Ecto.Changeset{
        valid?: true,
        changes: %{
          name: "Triceps",
          protocol_description: "regular",
          repetitions: "3x15",
          youtube_video_url: "www.test.com"
        },
        errors: []
      } = response
    end

    test "when misses a field in params, returns an error" do
      params = %{
        name: "Triceps",
        youtube_video_url: "www.test.com",
        repetitions: "3x15"
      }

      response = Exercise.changeset(%Exercise{}, params)

      expected_response = %{protocol_description: ["can't be blank"]}

      assert errors_on(response) == expected_response
    end
  end
end
