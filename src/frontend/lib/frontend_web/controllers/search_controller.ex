defmodule FrontendWeb.SearchController do
  use FrontendWeb, :controller
  require Logger

  def index(conn, %{"search" => search_string}) do
    conn = conn |> assign(:query, search_string)
    search_result = Frontend.MonitoredService.search(search_string)

    if Enum.count(search_result) == 0 do
      render(conn, "empty.html")
    else
      render(conn, "index.html", result: search_result)
    end
  end

  # Called when the user supplied no search query
  def index(conn, _params) do
    render(conn, "empty.html")
  end

end
