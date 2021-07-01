defmodule Wabanex.UserTest do
  use Wabanex.DataCase, async: true

  alias Wabanex.User

  describe "changeset/1" do
    test "when all params are valid, returns a valid changeset" do
      params = %{
        name: "Airton",
        email: "airton@cena.com",
        password: "123456",
        heigth: 1.75,
        weigth: 80.0,
        fat_index: 0.60,
        muscle_index: 0.40
      }

      response = User.changeset(params)

      assert %Ecto.Changeset{
        valid?: true,
        changes: %{
          name: "Airton",
          email: "airton@cena.com",
          password: "123456",
          heigth: 1.75,
          weigth: 80.0,
          fat_index: 0.60,
          muscle_index: 0.40
        },
        errors: []
      } = response
    end

    test "when misses a field in params, returns an error" do
      params = %{}

      response = User.changeset(params)

      expected_response = %{
        email: ["can't be blank"],
        heigth: ["can't be blank"],
        name: ["can't be blank"],
        password: ["can't be blank"],
        weigth: ["can't be blank"],
        fat_index: ["can't be blank"],
        muscle_index: ["can't be blank"]
      }
      assert errors_on(response) == expected_response
    end

    test "when put a password without a minimum of caracters in params, returns an error" do
      params = %{
        name: "Airton",
        email: "airton@cena.com",
        password: "12345",
        heigth: 1.75,
        weigth: 80.0,
        fat_index: 0.60,
        muscle_index: 0.40
      }

      response = User.changeset(params)

      expected_response = %{password: ["should be at least 6 character(s)"]}

      assert errors_on(response) == expected_response
    end

    test "when put a name without a minimum of caracters in params, returns an error" do
      params = %{
        name: "A",
        email: "airton@cena.com",
        password: "123456",
        heigth: 1.75,
        weigth: 80.0,
        fat_index: 0.60,
        muscle_index: 0.40
      }

      response = User.changeset(params)

      expected_response = %{name: ["should be at least 2 character(s)"]}

      assert errors_on(response) == expected_response
    end

    test "when put a invalid email in params, returns an error" do
      params = %{
        name: "Airton",
        email: "airtoncena.com",
        password: "123456",
        heigth: 1.75,
        weigth: 80.0,
        fat_index: 0.60,
        muscle_index: 0.40
      }

      response = User.changeset(params)

      expected_response = %{email: ["has invalid format"]}

      assert errors_on(response) == expected_response
    end
  end
end
