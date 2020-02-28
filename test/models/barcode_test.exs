defmodule Butler.BarcodeTest do
  use Butler.DataCase

  alias Butler.Barcode

  @valid_attrs %{size: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Barcode.changeset(%Barcode{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Barcode.changeset(%Barcode{}, @invalid_attrs)
    refute changeset.valid?
  end
end
