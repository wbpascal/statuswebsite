defmodule TokenServiceWeb.Router do
  use TokenServiceWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end
  
  scope "/healthz", TokenServiceWeb do
    get "/", HealthController, :alive
  end

  scope "/auth", TokenServiceWeb do
    match(:*, "/*path", AuthController, :authenticate)
  end

  scope "/", TokenServiceWeb do
    pipe_through :api
    post "/encode", TokenController, :encode
    post "/decode", TokenController, :decode
  end
end
