defmodule FeedMe.MealsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FeedMe.Meals` context.
  """

  @doc """
  Generate a saved_meals.
  """
  def saved_meals_fixture(attrs \\ %{}) do
    {:ok, saved_meals} =
      attrs
      |> Enum.into(%{
        ingredients: %{},
        meal_time: "some meal_time",
        name: "some name",
        total_calories: 42,
        total_carbs_in_grams: 42,
        total_fats_in_grams: 42,
        total_protein_in_grams: 42
      })
      |> FeedMe.Meals.create_saved_meals()

    saved_meals
  end
end
