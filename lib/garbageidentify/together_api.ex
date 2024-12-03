# lib/garbageidentify/together_api.ex

defmodule Garbageidentify.TogetherApi do
  use Tesla
  require Logger

  plug Tesla.Middleware.BaseUrl, "https://api.together.xyz"
  plug Tesla.Middleware.JSON

  plug Tesla.Middleware.Headers, [
    {"Authorization", "Bearer #{Application.get_env(:garbageidentify, :together_api)[:api_key]}"},
    {"Content-Type", "application/json"}
  ]

  def identify_garbage(image_base64) do
    Logger.info("Making request to Together API for validation")

    # First, validate if the image contains garbage
    validation_body = %{
      model: "meta-llama/Llama-3.2-11B-Vision-Instruct-Turbo",
      messages: [
        %{
          role: "user",
          content: [
            %{
              type: "text",
              text: "Does this image contain garbage, waste, or trash? Reply with only 'yes' or 'no'."
            },
            %{
              type: "image_url",
              image_url: %{
                url: "data:image/png;base64,#{image_base64}"
              }
            }
          ]
        }
      ],
      max_tokens: 512,
      temperature: 0.7,
      top_p: 0.7,
      top_k: 50
    }

    with {:ok, validation_response} <- post("/v1/chat/completions", validation_body),
         %{"choices" => [%{"message" => %{"content" => content}} | _]} <- validation_response.body do

      content = String.downcase(content)

      if String.contains?(content, "yes") do
        process_garbage_image(image_base64)
      else
        {:error, "This image does not appear to contain garbage. Please upload an image of waste materials."}
      end
    else
      error ->
        Logger.error("Validation error: #{inspect(error)}")
        {:error, "Failed to validate image content"}
    end
  end

  defp process_garbage_image(image_base64) do
    Logger.info("Processing validated garbage image")

    analysis_body = %{
      model: "meta-llama/Llama-3.2-11B-Vision-Instruct-Turbo",
      messages: [
        %{
          role: "user",
          content: [
            %{
              type: "text",
              text: "In 100 words or less, identify the type of garbage shown and provide a simple disposal recommendation."
            },
            %{
              type: "image_url",
              image_url: %{
                url: "data:image/png;base64,#{image_base64}"
              }
            }
          ]
        }
      ],
      max_tokens: 512,
      temperature: 0.7,
      top_p: 0.7,
      top_k: 50
    }

    case post("/v1/chat/completions", analysis_body) do
      {:ok, response} ->
        Logger.info("Together API Response: #{inspect(response.body)}")
        case response.body do
          %{"choices" => [%{"message" => %{"content" => content}} | _]} ->
            {:ok, format_response(content)}
          %{"error" => %{"message" => message}} ->
            Logger.error("API Error message: #{message}")
            {:error, "API Error: #{message}"}
          error ->
            Logger.error("Unexpected response format: #{inspect(error)}")
            {:error, "Unexpected response format from API"}
        end
      {:error, error} ->
        Logger.error("API Error: #{inspect(error)}")
        {:error, "API Error: #{inspect(error)}"}
    end
  end

  defp format_response(content) do
    # Split into type and recommendation if possible
    parts = String.split(content, ".")
    case parts do
      [type, recommendation | _] ->
        """
        Type: #{String.trim(type)}.

        Recommendation: #{String.trim(recommendation)}.
        """
      _ -> content
    end
  end
end
