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

  scope "/", Butler do
    pipe_through [:browser, :auth]

    get "/", PageController, :index
    post "/", PageController, :login
    post "/logout", PageController, :logout
  end

  scope "/", Butler do
    pipe_through [:browser, :auth, :ensure_auth] # Use the default browser stack

    resources "/maids", MaidController
    post "/maids/:id/check-in", MaidController, :check_in
    post "/maids/:id/check-out", MaidController, :check_out

    resources "/tables", TableController

    get "/switch-tables", SwitchTablesController, :index
    post "/switch-tables", SwitchTablesController, :switch

    resources "/waitlist", WaitlistController

    get "/parties/clear", PartyController, :clear
    post "/parties/clear", PartyController, :clear
    resources "/parties", PartyController

    get "/reservations/new/:table_id", ReservationController, :new
    get "/reservations/clear", ReservationController, :clear
    post "/reservations/clear", ReservationController, :clear
    get "/reservations/:id/seat/:table_id", ReservationController, :seat
    resources "/reservations", ReservationController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Butler do
  #   pipe_through :api
  # end
end
