defmodule FeedMe.MealPreferencesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FeedMe.MealPreferences` context.
  """

  @doc """
  Generate a meal_preference.
  """
  def meal_preference_fixture(attrs \\ %{}) do
    {:ok, meal_preference} =
      attrs
      |> Enum.into(%{
        activity_level: "some activity_level",
        allergies: ["option1", "option2"],
        carbs_in_grams: 42,
        daily_calorie_limit: 42,
        diet_type: "some diet_type",
        disliked_foods: ["option1", "option2"],
        fats_in_grams: 42,
        favorite_foods: ["option1", "option2"],
        meal_timing: %{},
        micronutrients: ["option1", "option2"],
        protein_in_grams: 42,
        special_conditions: "some special_conditions",
        water_intake: 120.5
      })
      |> FeedMe.MealPreferences.create_meal_preference()

    meal_preference
  end
end
