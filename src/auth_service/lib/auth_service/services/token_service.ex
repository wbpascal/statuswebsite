defmodule AuthService.Service.TokenService do
  use Tesla
  require Logger

  plug Tesla.Middleware.BaseUrl, "http://token-service"
  plug Tesla.Middleware.JSON

  def encode(%{id: uid, username: _} = claims) do
    # Rename id key to uid
    claims = claims |> Map.put(:uid, uid) |> Map.delete(:id)

    case post("/encode", claims) do
      {:ok, response} when is_map(response) ->
        Logger.debug("TokenService.encode | Got response: #{inspect response}")
        {:ok, Map.get(response.body, "token")}
      {:ok, err_response} -> {:error, "Invalid response. Response was: #{inspect err_response}"}
      err -> err
    end
  end

  def encode(_claims) do
    {:error, "Missing required parameters to encode token"}
  end

end
