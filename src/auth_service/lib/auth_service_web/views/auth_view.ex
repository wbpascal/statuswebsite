defmodule AuthServiceWeb.AuthView do
  use AuthServiceWeb, :view

  def render("token.json", %{token: token}) do
    %{token: token}
  end

end
