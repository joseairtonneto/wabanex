defmodule Wabanex.UserTest do
  use Wabanex.DataCase, async: true

  alias Wabanex.User

  describe "changeset/1" do
    test "when all params are valid, returns a valid changeset" do
      params = %{name: "Airton", email: "airton@cena.com", password: "123456"}

      response = User.changeset(params)

      assert %Ecto.Changeset{
        valid?: true,
        changes: %{email: "airton@cena.com", name: "Airton", password: "123456"},
        errors: []
      } = response
    end

    test "when misses a field in params, returns an error" do
      params = %{name: "Airton", email: "airton@cena.com"}

      response = User.changeset(params)
      expected_response = %{password: ["can't be blank"]}
      assert errors_on(response) == expected_response
    end

    test "when put a password without a minimum of caracters in params, returns an error" do
      params = %{email: "airton@cena.com", name: "Airton", password: "12345"}

      response = User.changeset(params)

      expected_response = %{password: ["should be at least 6 character(s)"]}

      assert errors_on(response) == expected_response
    end

    test "when put a name without a minimum of caracters in params, returns an error" do
      params = %{name: "A", email: "airton@cena.com", password: "123456"}

      response = User.changeset(params)

      expected_response = %{name: ["should be at least 2 character(s)"]}

      assert errors_on(response) == expected_response
    end

    test "when put a invalid email in params, returns an error" do
      params = %{name: "Airton", email: "airtoncena.com", password: "123456"}

      response = User.changeset(params)

      expected_response = %{email: ["has invalid format"]}

      assert errors_on(response) == expected_response
    end
  end
end
