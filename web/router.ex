defmodule Butler.Router do
  use Butler.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Butler.Auth.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :maybe_user do
    plug :fetch_current_user
  end

  def fetch_current_user(conn, _) do
    conn
    |> assign(:maybe_user, Guardian.Plug.current_resource(conn))
  end

  scope "/", Butler do
    pipe_through [:browser, :auth]

    get "/", PageController, :index

    get "/admin", AdminController, :index
    post "/admin", AdminController, :login
    post "/admin/logout", AdminController, :logout

    get "/ical", IcalController, :index
  end

  scope "/admin", Butler do
    pipe_through [:browser, :auth, :ensure_auth, :maybe_user] # Use the default browser stack

    resources "/maids", MaidController
    post "/maids/:id/check-in", MaidController, :check_in
    post "/maids/:id/check-out", MaidController, :check_out

    resources "/tables", TableController

    get "/switch-tables", SwitchTablesController, :index
    post "/switch-tables", SwitchTablesController, :switch

    resources "/waitlist", WaitlistController

    get "/barcodes/clear", BarcodeController, :clear
    post "/barcodes/clear", BarcodeController, :clear
    resources "/barcodes", BarcodeController

    get "/reservations/new/:table_id", ReservationController, :new
    get "/reservations/clear", ReservationController, :clear
    post "/reservations/clear", ReservationController, :clear
    get "/reservations/:id/seat/:table_id", ReservationController, :seat
    resources "/reservations", ReservationController

    resources "/timeslots", TimeslotController
  end

  # Other scopes may use custom stacks.
  scope "/api", Butler do
    pipe_through :api
    if Application.get_env(:butler, :env) == :cypress do
      forward("end-to-end", Plug.TestEndToEnd)
    end
  end
end
