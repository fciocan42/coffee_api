defmodule CoffeeApiWeb.Swagger do
  @moduledoc """
  Provides the OpenAPI (Swagger) specification for the API.
  """
  import PhoenixSwagger

  def swagger_info do
    %{
      info: %{
        version: "1.0.0",
        title: "Coffee Shop Finder API"
      },
      paths: %{
        "/api/coffee_shops": %{
          get: %{
            summary: "Find closest coffee shops",
            parameters: [
              %{
                in: "query",
                name: "lat",
                description: "User's latitude",
                required: true,
                type: "number",
                format: "float"
              },
              %{
                in: "query",
                name: "lon",
                description: "User's longitude",
                required: true,
                type: "number",
                format: "float"
              }
            ],
            responses: %{
              "200" => %{
                description: "A list of the three closest coffee shops",
                schema: %Schema{
                  type: :object,
                  properties: %{
                    data: %Schema{
                      type: :array,
                      items: %Schema{
                        type: :object,
                        properties: %{
                          name: %Schema{type: :string},
                          location: %Schema{type: :array, items: %Schema{type: :number, format: :float}},
                          distance: %Schema{type: :number, format: :float}
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  end
end
