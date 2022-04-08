defmodule Butler.PageController do
  use Butler.Web, :controller

  def index(conn, _params) do
    render(conn, "index.html", layout: {Butler.LayoutView, "patrons.html"})
  end
end
