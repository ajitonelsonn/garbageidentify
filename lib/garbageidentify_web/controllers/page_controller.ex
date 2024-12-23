# lib/garbageidentify_web/controllers/page_controller.ex

defmodule GarbageidentifyWeb.PageController do
  use GarbageidentifyWeb, :controller
  require Logger

  def home(conn, _params) do
    conn
    |> assign(:page_title, "Home")
    |> render(:home)
  end

  def about(conn, _params) do
    conn
    |> assign(:page_title, "About")
    |> render(:about)
  end

  def guide(conn, _params) do
    conn
    |> assign(:page_title, "Recycling Guide")
    |> render(:guide)
  end

  def contact(conn, _params) do
    conn
    |> assign(:page_title, "Contact")
    |> render(:contact)
  end

  def faq(conn, _params) do
    conn
    |> assign(:page_title, "FAQ")
    |> render(:faq)
  end

  def blog(conn, _params) do
    conn
    |> assign(:page_title, "Blog")
    |> render(:blog)
  end

  def privacy(conn, _params) do
    conn
    |> assign(:page_title, "Privacy Policy")
    |> render(:privacy)
  end

  def terms(conn, _params) do
    conn
    |> assign(:page_title, "Terms of Service")
    |> render(:terms)
  end

  def sitemap(conn, _params) do
    conn
    |> assign(:page_title, "Sitemap")
    |> render(:sitemap)
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
