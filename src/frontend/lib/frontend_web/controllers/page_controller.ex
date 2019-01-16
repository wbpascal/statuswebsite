defmodule FrontendWeb.PageController do
  use FrontendWeb, :controller
  require Logger

  def index(%{req_headers: headers} = conn, _params) do
    render(conn, "index.html")
  end

  def create_token(conn, %{"uid" => uid}) do
    %HTTPoison.Response{body: body} = HTTPoison.post!("http://auth-service/token/create", {:form, [uid: uid]})

    conn
    |> send_resp(200, body)
  end
end
