defmodule WabanexWeb.SchemaTest do
  use WabanexWeb.ConnCase, async: true

  alias Wabanex.{Training, User}
  alias Wabanex.Trainings.Create, as: TrainingCreate
  alias Wabanex.Users.Create, as: UserCreate

  describe "users queries" do
    test "when a valid id is given, returns the user", %{conn: conn} do
      params = %{
        name: "Airton",
        email: "airton@cena.com",
        password: "123456",
        heigth: 1.75,
        weigth: 80.0,
        fat_index: 0.60,
        muscle_index: 0.40
      }

      {:ok, %User{id: user_id}} = UserCreate.call(params)

      training = %{
        start_date: "2021-06-11",
        end_date: "2021-07-11",
        user_id: "#{user_id}",
        exercises: [
            %{
            name: "Triceps banco",
            youtube_video_url: "www.google.com",
            repetitions: "3x15",
            protocol_description: "drop-set"
          },
          %{
            name: "Triceps",
            youtube_video_url: "www.google.com",
            repetitions: "3x10",
            protocol_description: "regular"
          }
        ]
      }

      {:ok, %Training{}} = TrainingCreate.call(training)

      query = """
        {
          getUser(id: "#{user_id}"){
            name
            email
            trainings {
              startDate
              endDate
              exercises {
                name
                repetitions
                protocolDescription
                youtubeVideoUrl
              }
            }
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
            "name" => "Airton",
            "trainings" => [
              %{
                "endDate" => "2021-07-11",
                "exercises" => [
                  %{
                    "name" => "Triceps banco",
                    "protocolDescription" => "drop-set",
                    "repetitions" => "3x15",
                    "youtubeVideoUrl" => "www.google.com"
                  },
                  %{
                    "name" =>
                    "Triceps",
                    "protocolDescription" => "regular",
                    "repetitions" => "3x10",
                    "youtubeVideoUrl" => "www.google.com"
                    }
                ],
                "startDate" => "2021-06-11"
              }
            ]
          }
        }
      }

      assert response == expected_response
    end
  end

  describe "users mutations" do
    test "when all params are valid, creates the user", %{conn: conn} do
      mutation = """
        mutation {
          createUser(input: {
            name: "Neto",
            email: "neto@craque.com",
            password: "123456",
            heigth: 1.75,
            weigth: 75.0,
            fatIndex: 0.30,
            muscleIndex: 0.70
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

    test "when a valid param is given, updates the user", %{conn: conn} do
      mutation = """
        mutation {
          createUser(input: {
            name: "Neto",
            email: "neto@craque.com",
            password: "123456",
            heigth: 1.75,
            weigth: 75.0,
            fatIndex: 0.30,
            muscleIndex: 0.70
          }) {
            id
          }
        }
      """
      response =
        conn
        |> post("/api/graphql", %{query: mutation})
        |> json_response(:ok)

      user_id = Map.get(response, "data") |> Map.get("createUser") |> Map.get("id")

      mutation = """
        mutation {
          updateUser(id: "#{user_id}", input: {name: "Ceninha"}){
            email,
            name
          }
        }
      """

      response =
        conn
        |> post("/api/graphql", %{query: mutation})
        |> json_response(:ok)

      assert %{
        "data" => %{
          "updateUser" => %{
            "email" => "neto@craque.com",
            "name" => "Ceninha"
          }
        }
      } = response
    end

    test "when a valid user_id is given, deletes the user", %{conn: conn} do
      mutation = """
        mutation {
          createUser(input: {
            name: "Neto",
            email: "neto@craque.com",
            password: "123456",
            heigth: 1.75,
            weigth: 75.0,
            fatIndex: 0.30,
            muscleIndex: 0.70
          }) {
            id
          }
        }
      """
      response =
        conn
        |> post("/api/graphql", %{query: mutation})
        |> json_response(:ok)

      user_id = Map.get(response, "data") |> Map.get("createUser") |> Map.get("id")

      mutation = """
        mutation {
          deleteUser(id: "#{user_id}") {
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
          "deleteUser" => %{
            "email" => "neto@craque.com",
            "name" => "Neto"
          }
        }
      } = response
    end
  end

  describe "trainings mutations" do
    test "when a valid user_id is given, returns the training", %{conn: conn} do
      params = %{
        name: "Airton",
        email: "airton@cena.com",
        password: "123456",
        heigth: 1.75,
        weigth: 80.0,
        fat_index: 0.60,
        muscle_index: 0.40
      }

      {:ok, %User{id: user_id}} = UserCreate.call(params)

      mutation = """
      mutation {
        createTraining(input: {
          endDate: "2021-09-11",
          startDate: "2021-08-11",
          userId: "#{user_id}",
          exercises: [
            {
              name: "Triceps banco",
              youtubeVideoUrl: "www.google.com",
              repetitions: "3x15",
              protocolDescription: "drop-set"
            },
            {
              name: "Triceps",
              youtubeVideoUrl: "www.google.com",
              repetitions: "3x10",
              protocolDescription: "regular"
            }
          ]
        }) {
          exercises{
            name,
            protocolDescription,
            repetitions,
            youtubeVideoUrl
          }
        }
      }
      """

      response =
        conn
        |> post("/api/graphql", %{query: mutation})
        |> json_response(:ok)

      expected_response = %{
        "data" => %{
          "createTraining" => %{
            "exercises" => [
              %{
                "name" => "Triceps banco",
                "protocolDescription" => "drop-set",
                "repetitions" => "3x15",
                "youtubeVideoUrl" => "www.google.com"
              },
              %{
                "name" =>
                "Triceps",
                "protocolDescription" => "regular",
                "repetitions" => "3x10",
                "youtubeVideoUrl" => "www.google.com"
              }
            ]
          }
        }
      }

      assert response == expected_response
    end
  end
end
