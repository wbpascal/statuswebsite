defmodule AuthServiceWeb.Router do
  use AuthServiceWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/healthz", AuthServiceWeb do
    get "/", HealthController, :alive
  end

  scope "/", AuthServiceWeb do
    pipe_through :api
    post "/authenticate", AuthController, :authenticate
  end
end
