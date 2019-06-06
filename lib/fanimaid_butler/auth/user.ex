defmodule FanimaidButler.Auth.User do
  @moduledoc """
  Placeholder moduledoc
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Comeonin.Bcrypt
  alias FanimaidButler.Auth.User

  schema "users" do
    field :password, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :password])
    |> validate_required([:username, :password])
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Bcrypt.hashpwsalt(password))
  end

  defp put_pass_hash(changeset), do: changeset
end
