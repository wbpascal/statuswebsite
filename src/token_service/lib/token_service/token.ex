defmodule TokenService.Token do
  use Joken.Config
  require Logger

  @impl true
  def token_config do
    default_claims(iss: "", default_exp: 3 * 24 * 60 * 60, skip: ["aud", "jti"])
    |> add_claim("uid", nil, &is_valid_uid/1)
  end

  def default_signer(), do: Joken.Signer.create("HS256", Application.fetch_env!(:token_service, :jwt_secret))

  def encode(%{"uid" => uid, "username" => _} = token_info) do
    {exp, token_info} = Map.pop(token_info, "expiration")
    {nbf, token_info} = Map.pop(token_info, "notbefore")

    Logger.debug("token_info 1: #{inspect token_info}")

    token_info =
      if exp != nil and is_valid_unix_timestamp(exp) do
        Map.put(token_info, "exp", exp)
      else
        token_info
      end
    token_info =
      if nbf != nil and is_valid_unix_timestamp(nbf) do
        Map.put(token_info, "nbf", nbf)
      else
        token_info
      end
    
    Logger.debug("token_info 2: #{inspect token_info}")

    token_info =
      token_info
      |> Map.put("sub", uid)
      |> Map.delete("uid")

    signer = default_signer()
    case Joken.generate_and_sign(token_config(), token_info, signer, []) do
      {:ok, encoded_token, _} ->
        {:ok, encoded_token}
      error ->
        error
    end
  end

  def encode(_) do
    {:error, "Invalid token"}
  end

  def decode(token_string) do
    signer = default_signer()

    case verify_and_validate(token_string, signer) do
      {:ok, claims} ->
        {uid, claims} = Map.pop(claims, "sub")
        {expiration, claims} = Map.pop(claims, "exp")
        {notbefore, claims} = Map.pop(claims, "nbf")

        claims =
          claims
          |> Map.drop(["iss"])
          |> Map.put("uid", uid)
          |> Map.put("expiration", expiration)
          |> Map.put("notbefore", notbefore)

        {:ok, claims}
      error ->
        error
    end
  end

  defp is_valid_uid(uid), do: Integer.parse(uid) != nil

  defp is_valid_unix_timestamp(candidate) do
    case DateTime.from_unix(candidate) do
      {:ok, _} -> true
      _ -> false
    end
  end
end
