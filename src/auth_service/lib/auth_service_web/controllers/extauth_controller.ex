defmodule AuthServiceWeb.Controller.ExtauthController do
  use AuthServiceWeb, :controller

  def authenticate(conn, _) do
    signer_secret = Application.fetch_env!(:auth_service, :jwt_secret)
    signer = Joken.Signer.create("HS256", signer_secret)

    with token_string <- get_token(conn),
         {:ok, claims} <- AuthService.Token.verify_and_validate(token_string, signer),
         {:ok, claims_json} <- Jason.encode(claims) do
      conn
      |> put_resp_header("x-jwt-claims", claims_json)
      |> send_resp(200, "")
    else
      _ -> conn |> send_resp(200, "")
    end
  end

  def get_token(conn) do
    conn = fetch_cookies(conn)
    %{req_headers: headers, req_cookies: cookies} = conn

    auth_header = List.keyfind(headers, "authorization", 0, {0, ""}) |> elem(1)

    cond do
      auth_header |> String.starts_with?("Bearer ") ->
        prefix_length = String.length("Bearer ")
        auth_header |> String.slice(prefix_length..-1)
      Map.get(cookies, "jwt", nil) != nil ->
        Map.get(cookies, "jwt", "")
      true ->
        ""
    end
  end
end
