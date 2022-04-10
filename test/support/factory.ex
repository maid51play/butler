defmodule Butler.Factory do
  @moduledoc """
  Placeholder moduledoc
  """

  use ExMachina.Ecto, repo: Butler.Repo

  alias Butler.Auth.User
  alias Butler.Maid
  alias Butler.Barcode
  alias Butler.Reservation
  alias Butler.Table
  alias Butler.Timeslot
  alias Comeonin.Bcrypt

  def user_factory do
    %User{
      username: "Admin",
      password: Bcrypt.hashpwsalt("password")
    }
  end

  def reservation_factory(attrs \\ %{}) do
    barcode_id = Map.get(attrs, :barcode_id, nil)
    barcode = Map.get(attrs, :barcode, nil)

    reservation = merge_attributes(%Reservation{
      size: 2,
      shinkansen: false,
      staff: false,
      time_in: "2010-04-17 14:00:00.000000Z",
      notes: "",
      maid: build(:maid)
    }, attrs)

    if is_nil(barcode_id) && is_nil(barcode) do
      %Reservation{reservation | barcode: build(:barcode)}
    else
      reservation
    end
  end

  def barcode_factory(attrs \\ %{}) do
    table_id = Map.get(attrs, :table_id, nil)
    table = Map.get(attrs, :table, nil)
    barcode = merge_attributes(%Barcode{}, attrs)
    
    if is_nil(table_id) && is_nil(table) do
      %Barcode{barcode | table: build(:table)}
    else
      barcode
    end
  end

  def table_factory do
    %Table{
      table_number: sequence("A"),
      max_capacity: 4
    }
  end

  def maid_factory do
    %Maid{
    }
  end

  def timeslot_factory do
    %Timeslot{
    }
  end

  # def article_factory do
  #   title = sequence(:title, &"Use ExMachina! (Part #{&1})")
  #   # derived attribute
  #   slug = Butler.Article.title_to_slug(title)
  #   %Butler.Article{
  #     title: title,
  #     slug: slug,
  #     # associations are inserted when you call `insert`
  #     author: build(:user),
  #   }
  # end

  # # derived factory
  # def featured_article_factory do
  #   struct!(
  #     article_factory(),
  #     %{
  #       featured: true,
  #     }
  #   )
  # end

  # def comment_factory do
  #   %Butler.Comment{
  #     text: "It's great!",
  #     article: build(:article),
  #   }
  # end
end
