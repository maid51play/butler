defmodule Butler.AdminControllerTest do
  use Butler.ConnCase

  test "GET /", %{conn: conn} do
    conn = conn
      |> authorize
      |> get("/admin")

    assert html_response(conn, 200) =~ "Fanimaid Butler BETA"
  end
end
