defmodule AuthServiceWeb.Router do
  use AuthServiceWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", AuthServiceWeb do
    pipe_through :api
  end
end
