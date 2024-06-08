defmodule FeedMe.Meals.SavedMeals do
  use Ecto.Schema
  import Ecto.Changeset

  schema "saved_meals" do
    field :name, :string
    field :meal_time, :string
    field :ingredients, :map
    field :total_calories, :integer
    field :total_fats_in_grams, :integer
    field :total_protein_in_grams, :integer
    field :total_carbs_in_grams, :integer
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(saved_meals, attrs) do
    saved_meals
    |> cast(attrs, [:name, :meal_time, :ingredients, :total_calories, :total_fats_in_grams, :total_protein_in_grams, :total_carbs_in_grams])
    |> validate_required([:name, :meal_time, :total_calories, :total_fats_in_grams, :total_protein_in_grams, :total_carbs_in_grams])
  end
end
