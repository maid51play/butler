defmodule FanimaidButler.PageController do
  use FanimaidButler.Web, :controller

  alias FanimaidButler.Auth
  alias FanimaidButler.Auth.Guardian
  alias FanimaidButler.Auth.User

  def index(conn, _params) do
    changeset = Auth.change_user(%User{})
    maybe_user = Guardian.Plug.current_resource(conn)

    render(conn, "index.html", changeset: changeset, action: page_path(conn, :login), maybe_user: maybe_user)
  end

  def login(conn, %{"user" => %{"username" => username, "password" => password}}) do
    username
      |> Auth.authenticate_user(password)
      |> login_reply(conn)
  end

  defp login_reply({:error, error}, conn) do
    conn
      |> put_flash(:error, error)
      |> redirect(to: "/")
  end

  defp login_reply({:ok, user}, conn) do
    conn
      |> put_flash(:success, "Welcome back!")
      |> Guardian.Plug.sign_in(user)
      |> redirect(to: "/")
  end

  def logout(conn, _) do
    conn
      |> Guardian.Plug.sign_out()
      |> redirect(to: page_path(conn, :login))
  end
end
