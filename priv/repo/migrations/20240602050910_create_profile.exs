defmodule FeedMe.Repo.Migrations.CreateProfile do
  use Ecto.Migration

  def change do
    create table(:profile) do
      add :bio, :text
      add :profile_picture_url, :string
      add :first_name, :string
      add :last_name, :string
      add :weight, :integer
      add :height, :integer
      add :date_of_birth, :date
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:profile, [:user_id])
  end
end
