defmodule FeedMe.Profiles.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "profile" do
    field :bio, :string
    field :profile_picture_url, :string
    field :first_name, :string
    field :last_name, :string
    field :weight, :integer
    field :height, :integer
    field :date_of_birth, :date
    belongs_to :user, FeedMe.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:bio, :profile_picture_url, :first_name, :last_name, :weight, :height, :date_of_birth])
    |> validate_required([:first_name, :last_name, :weight, :height, :date_of_birth])
  end
end
