# lib/garbageidentify_web/controllers/page_controller.ex

defmodule GarbageidentifyWeb.PageController do
  use GarbageidentifyWeb, :controller
  require Logger

  def home(conn, _params) do
    render(conn, :home)
  end

  def upload(conn, %{"image" => image_params}) do
    Logger.info("Received upload request with params: #{inspect(image_params)}")

    with {:ok, image_binary} <- File.read(image_params.path),
         image_base64 <- Base.encode64(image_binary),
         {:ok, result} <- Garbageidentify.TogetherApi.identify_garbage(image_base64) do

      Logger.info("Successfully processed image")

      conn
      |> put_status(:ok)
      |> json(%{
        status: "success",
        result: result
      })
    else
      {:error, error} ->
        Logger.error("Failed to process image: #{inspect(error)}")

        conn
        |> put_status(:bad_request)
        |> json(%{
          status: "error",
          error: case error do
            "API Error: " <> message -> message
            _ -> "Failed to process image: #{inspect(error)}"
          end
        })
    end
  end
end
