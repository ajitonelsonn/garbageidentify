# lib/garbageidentify_web/router.ex

defmodule GarbageidentifyWeb.Router do
  use GarbageidentifyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {GarbageidentifyWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GarbageidentifyWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/api", GarbageidentifyWeb do
    pipe_through :api

    post "/upload", PageController, :upload
  end
end
