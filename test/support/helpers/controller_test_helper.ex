# TODO: is this a good namespace?
defmodule Butler.Tests.ControllerTestHelpers do
  @moduledoc """
  Placeholder moduledoc
  """

  import Plug.Conn
  import Butler.Factory
  import Butler.Auth.Guardian

  def authorize(conn) do
    user = insert(:user)

    {:ok, token, _} = encode_and_sign(user, %{})

    conn
      |> put_req_header("authorization", "bearer: " <> token)
  end
end
