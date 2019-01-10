defmodule TokenServiceWeb.Controller.TokenController do
  use TokenServiceWeb, :controller

  def encode(conn, claims) do
    case TokenService.Token.encode(claims) do
      {:ok, encoded_token} ->
        conn |> json(%{token: encoded_token})
      err ->
        conn |> send_resp(400, "#{inspect err}")
    end
  end

  def decode(conn, %{token: encoded_token}) do
    case TokenService.Token.decode(encoded_token) do
      {:ok, claims} ->
        conn |> json(claims)
      _ ->
        conn |> send_resp(400, "")
    end
  end

end
