defmodule TokenServiceWeb.HealthController do
  use TokenServiceWeb, :controller
  require Logger

  def alive(conn, _params) do
    Logger.debug("Received alive request")
    conn |> send_resp(200, "OK")
  end

end
