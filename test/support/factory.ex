defmodule FanimaidButler.Factory do
  use ExMachina.Ecto, repo: FanimaidButler.Repo

  alias FanimaidButler.Auth.User
  alias FanimaidButler.Reservation
  alias FanimaidButler.Party
  alias FanimaidButler.Table
  alias FanimaidButler.Maid

  def user_factory do
    %User{
      username: "Admin",
    }
  end

  def reservation_factory do
    %Reservation{
      size: 2,
      shinkansen: false,
      staff: false,
      time_in: "2010-04-17 14:00:00.000000Z",
      notes: "",
      party: build(:party),
      maid: build(:maid)
    }
  end

  def party_factory do
    %Party{
      table: build(:table),
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
  #   slug = FanimaidButler.Article.title_to_slug(title)
  #   %FanimaidButler.Article{
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
  #   %FanimaidButler.Comment{
  #     text: "It's great!",
  #     article: build(:article),
  #   }
  # end
end