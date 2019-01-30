defmodule FrontendWeb.Router do
  use FrontendWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/healthz", FrontendWeb do
    get "/", HealthController, :alive
  end

  scope "/", FrontendWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/search", SearchController, :index
    get "/:id", HostController, :index
  end
end
