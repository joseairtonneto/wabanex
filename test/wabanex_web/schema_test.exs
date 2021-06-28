defmodule WabanexWeb.SchemaTest do
  use WabanexWeb.ConnCase, async: true

  alias Wabanex.User
  alias Wabanex.Users.Create

  describe "users queries" do
    test "when a valid id is given, returns the user", %{conn: conn} do
      params = %{email: "airton@cena.com", name: "Airton", password: "123456"}

      {:ok, %User{id: user_id}} = Create.call(params)

      query = """
        {
          getUser(id: "#{user_id}"){
            name
            email
          }
        }
      """

      response =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(:ok)

      expected_response = %{
        "data" => %{
          "getUser" => %{
            "email" => "airton@cena.com",
            "name" => "Airton"
          }
        }
      }

      assert expected_response == response
    end
  end

  describe "users mutations" do
    test "when all params are valid, creates the user", %{conn: conn} do
      mutation = """
        mutation {
          createUser(input: {
            name: "Neto",
            email: "neto@craque.com",
            password: "123456"
          }) {
            id
            name
            email
          }
        }
      """
      response =
        conn
        |> post("/api/graphql", %{query: mutation})
        |> json_response(:ok)

      assert %{
        "data" => %{
          "createUser" => %{
            "email" => "neto@craque.com",
            "id" => _id,
            "name" => "Neto"
          }
        }
      } = response
    end
  end
end
