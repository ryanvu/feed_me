defmodule FeedMe.Repo.Migrations.CreateMealPreferences do
  use Ecto.Migration

  def change do
    create table(:meal_preferences) do
      add :daily_calorie_limit, :integer
      add :fats_in_grams, :integer
      add :carbs_in_grams, :integer
      add :protein_in_grams, :integer
      add :diet_type, :string
      add :allergies, {:array, :string}
      add :favorite_foods, {:array, :string}
      add :disliked_foods, {:array, :string}
      add :meal_timing, :map
      add :water_intake, :float
      add :micronutrients, {:array, :string}
      add :special_conditions, :string
      add :activity_level, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:meal_preferences, [:user_id])
  end
end
