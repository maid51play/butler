defmodule FanimaidButler.RoomChannel do
  use Phoenix.Channel

  alias FanimaidButler.Reservation

  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end
  
  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("table_cleared", %{"body" => body}, socket) do
    broadcast!(socket, "table_cleared", %{body: body})
    {:noreply, socket}
  end

  def handle_in("waitlist_seated", %{"body" => body}, socket) do
    broadcast!(socket, "waitlist_seated", %{body: body})
    {:noreply, socket}
  end

  def handle_in("waitlist_updated", %{"body" => body}, socket) do
    broadcast!(socket, "waitlist_updated", %{body: body})
    {:noreply, socket}
  end

  def handle_in("new_waitlist_entries", %{"body" => body}, socket) do
    waitlist = FanimaidButler.WaitlistController.new_waitlist_entries(body)
    push(socket, "new_waitlist_entries", %{body: waitlist})
    {:noreply, socket}
  end
end