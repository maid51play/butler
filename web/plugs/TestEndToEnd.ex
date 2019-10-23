defmodule Butler.Plug.TestEndToEnd do
  @moduledoc """
  Placeholder moduledoc
  """
  use Plug.Router
  alias Butler.Repo
  alias Butler.Factory

  plug :match
  plug :dispatch

  post "/db/checkout" do
    # If the agent is registered and alive, a db connection is checked out already
    # Otherwise, we spawn the agent and let it(!) check out the db connection
    owner_process = Process.whereis(:db_owner_agent)
    if owner_process && Process.alive?(owner_process) do
      send_resp(conn, 200, "connection has already been checked out")
    else
      {:ok, _pid} = Agent.start_link(&checkout_shared_db_conn/0, name: :db_owner_agent)
      send_resp(conn, 200, "checked out database connection")
    end
  end
  
  post "/db/checkin" do
    # If the agent is registered and alive, we check the connection back in
    # Otherwise, no connection has been checked out, we ignore this
    owner_process = Process.whereis(:db_owner_agent)
    if owner_process && Process.alive?(owner_process) do
      Agent.get(owner_process, &checkin_shared_db_conn/1)
      Agent.stop(owner_process)
      send_resp(conn, 200, "checked in database connection")
    else
      send_resp(conn, 200, "connection has already been checked back in")
    end
  end

  post "/db/factory" do
    # When piped through a generic Phoenix JSON API pipeline, using a route
    # like this allows you to call your factory via your test API easily.
    with {:ok, schema} <- Map.fetch(conn.body_params, "schema"),
          {:ok, attrs} <- Map.fetch(conn.body_params, "attributes") do
      
      db_schema = String.to_atom(schema)
      db_attrs = Enum.map(attrs, fn {k, v} -> {String.to_atom(k), v} end)
      db_entry = Factory.insert(db_schema, db_attrs)
      send_resp(conn, 200, Poison.encode!(%{id: db_entry.id}))
    else
      _ -> send_resp(conn, 401, "schema or attributes missing")
    end
  end

  # match _, do: send_resp(conn, 404, "not found")

  defp checkout_shared_db_conn do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo, ownership_timeout: :infinity)
    :ok = Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})
  end
  
  defp checkin_shared_db_conn(_) do
    :ok = Ecto.Adapters.SQL.Sandbox.checkin(Repo)
  end
end