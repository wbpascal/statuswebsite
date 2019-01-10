defmodule TokenServiceWeb.Router do
  use TokenServiceWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/auth", TokenServiceWeb do
    match(:*, "/*path", Controller.AuthController, :authenticate)
  end

  scope "/", TokenServiceWeb do
    pipe_through :api
    post "/encode", Controller.TokenController, :encode
    post "/decode", Controller.TokenController, :decode
  end
end
