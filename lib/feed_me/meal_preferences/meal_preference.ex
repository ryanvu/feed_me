defmodule FeedMe.MealPreferences.MealPreference do
  use Ecto.Schema
  import Ecto.Changeset

  schema "meal_preferences" do
    field :daily_calorie_limit, :integer
    field :fats_in_grams, :integer
    field :carbs_in_grams, :integer
    field :protein_in_grams, :integer
    field :diet_type, :string
    field :allergies, {:array, :string}
    field :favorite_foods, {:array, :string}
    field :disliked_foods, {:array, :string}
    field :meal_timing, :map
    field :water_intake, :float
    field :micronutrients, {:array, :string}
    field :special_conditions, :string
    field :activity_level, :string
    belongs_to :user, FeedMe.Accounts.User
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(meal_preference, attrs) do
    meal_preference
    |> cast(attrs, [
      :daily_calorie_limit,
      :fats_in_grams,
      :carbs_in_grams,
      :protein_in_grams,
      :diet_type,
      :allergies,
      :favorite_foods,
      :disliked_foods,
      :meal_timing,
      :water_intake,
      :micronutrients,
      :special_conditions,
      :activity_level
    ])
    |> validate_required([
      :daily_calorie_limit,
      :fats_in_grams,
      :carbs_in_grams,
      :protein_in_grams
    ])
    |> validate_number(:daily_calorie_limit, greater_than_or_equal_to: 0)
    |> validate_number(:fats_in_grams, greater_than_or_equal_to: 0)
    |> validate_number(:carbs_in_grams, greater_than_or_equal_to: 0)
    |> validate_number(:protein_in_grams, greater_than_or_equal_to: 0)
  end
end
