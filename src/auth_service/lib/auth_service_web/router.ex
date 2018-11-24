defmodule AuthServiceWeb.Router do
  use AuthServiceWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/auth", AuthServiceWeb do
    match(:*, "/*path", Controller.AuthController, :authenticate)
  end

  scope "/token", AuthServiceWeb do
    pipe_through :api
    post "/create", Controller.TokenController, :create
  end

  scope "/api", AuthServiceWeb do
    pipe_through :api
  end
end
