defmodule AuthServiceWeb.AuthController do
  use AuthServiceWeb, :controller

  alias AuthService.{Repo, User}
  require Logger

  def authenticate(conn, %{"username" => username, "password" => password}) do
    with user <- Repo.get_by(User, username: username),
         {:ok, user} <- Comeonin.Bcrypt.check_pass(user, password),
         {:ok, token} <- user |> Map.take([:id, :username]) |> AuthService.Service.TokenService.encode() do
      render(conn, "token.json", %{token: token})
    else
      {:error, message} ->
        Logger.debug("Authentication: Error while authenticating user. Error was: #{inspect message}")
        send_resp(conn, 400, "")
      error ->
        Logger.debug("Authentication: Unexpected value while authenticating user. Value was: #{inspect error}")
        send_resp(conn, 400, "")
    end
  end

end
