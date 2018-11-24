defmodule AuthService.Token do
  use Joken.Config

  @impl true
  def token_config do
    default_claims(iss: "", skip: ["aud", "jti", "nbf"])
    |> add_claim("uid", nil, &is_valid_uid/1)
  end

  def default_signer(), do: Joken.Signer.create("HS256", Application.fetch_env!(:auth_service, :jwt_secret))

  defp is_valid_uid(uid), do: Integer.parse(uid) != nil
end
