defmodule Butler.Factory do
  @moduledoc """
  Placeholder moduledoc
  """

  use ExMachina.Ecto, repo: Butler.Repo

  alias Butler.Auth.User
  alias Butler.Maid
  alias Butler.Party
  alias Butler.Reservation
  alias Butler.Table
  alias Comeonin.Bcrypt

  def user_factory do
    %User{
      username: "Admin",
      password: Bcrypt.hashpwsalt("password")
    }
  end

  def reservation_factory do
    %Reservation{
      size: 2,
      shinkansen: false,
      staff: false,
      time_in: "2010-04-17 14:00:00.000000Z",
      notes: "",
      # party: build(:party),
      maid: build(:maid)
    }
  end

  def party_factory do
    %Party{
      # table: build(:table),
    }
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
