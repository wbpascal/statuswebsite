defmodule AuthServiceWeb.Controller.TokenController do
  use AuthServiceWeb, :controller

  def create(conn, %{"uid" => uid} = claims) do
    signer = AuthService.Token.default_signer()

    case AuthService.Token.generate_and_sign(claims, signer) do
      {:ok, encoded_token, token} ->
        conn |> json(%{error: false, token: encoded_token})
      _ ->
        conn |> json(%{error: true, reason: "Could not create token"})
    end
  end

  def create(conn, _) do
    conn
    |> json(%{error: true, reason: "Requires user_id field"})
  end

end
