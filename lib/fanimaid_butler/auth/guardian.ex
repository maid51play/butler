defmodule Butler.Auth.Guardian do
  @moduledoc """
  Placeholder moduledoc
  """
  use Guardian, otp_app: :fanimaid_butler
  alias Butler.Auth

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(claims) do
    user = claims["sub"]
    |> Auth.get_user!
    {:ok, user}
    # If something goes wrong here return {:error, reason}
  end
end
