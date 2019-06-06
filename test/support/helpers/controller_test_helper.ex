# TODO: is this a good namespace?
defmodule FanimaidButler.Tests.ControllerTestHelpers do
  @moduledoc """
  Placeholder moduledoc
  """

  import Plug.Conn
  import FanimaidButler.Factory
  import FanimaidButler.Auth.Guardian

  def authorize(conn) do
    user = insert(:user)

    {:ok, token, _} = encode_and_sign(user, %{})

    conn
      |> put_req_header("authorization", "bearer: " <> token)
  end
end
