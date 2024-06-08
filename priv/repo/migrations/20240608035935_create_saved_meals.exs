defmodule FeedMe.Repo.Migrations.CreateSavedMeals do
  use Ecto.Migration

  def change do
    create table(:saved_meals) do
      add :name, :string
      add :meal_time, :string
      add :ingredients, :map
      add :total_calories, :integer
      add :total_fats_in_grams, :integer
      add :total_protein_in_grams, :integer
      add :total_carbs_in_grams, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:saved_meals, [:user_id])
  end
end
