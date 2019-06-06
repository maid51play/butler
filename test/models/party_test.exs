defmodule Butler.PartyTest do
  use Butler.DataCase

  alias Butler.Party

  @valid_attrs %{size: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Party.changeset(%Party{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Party.changeset(%Party{}, @invalid_attrs)
    refute changeset.valid?
  end
end
