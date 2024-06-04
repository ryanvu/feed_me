defmodule FeedMe.MealPreferencesTest do
  use FeedMe.DataCase

  alias FeedMe.MealPreferences

  describe "meal_preferences" do
    alias FeedMe.MealPreferences.MealPreference

    import FeedMe.MealPreferencesFixtures

    @invalid_attrs %{daily_calorie_limit: nil, fats_in_grams: nil, carbs_in_grams: nil, protein_in_grams: nil, diet_type: nil, allergies: nil, favorite_foods: nil, disliked_foods: nil, meal_timing: nil, water_intake: nil, micronutrients: nil, special_conditions: nil, activity_level: nil}

    test "list_meal_preferences/0 returns all meal_preferences" do
      meal_preference = meal_preference_fixture()
      assert MealPreferences.list_meal_preferences() == [meal_preference]
    end

    test "get_meal_preference!/1 returns the meal_preference with given id" do
      meal_preference = meal_preference_fixture()
      assert MealPreferences.get_meal_preference!(meal_preference.id) == meal_preference
    end

    test "create_meal_preference/1 with valid data creates a meal_preference" do
      valid_attrs = %{daily_calorie_limit: 42, fats_in_grams: 42, carbs_in_grams: 42, protein_in_grams: 42, diet_type: "some diet_type", allergies: ["option1", "option2"], favorite_foods: ["option1", "option2"], disliked_foods: ["option1", "option2"], meal_timing: %{}, water_intake: 120.5, micronutrients: ["option1", "option2"], special_conditions: "some special_conditions", activity_level: "some activity_level"}

      assert {:ok, %MealPreference{} = meal_preference} = MealPreferences.create_meal_preference(valid_attrs)
      assert meal_preference.daily_calorie_limit == 42
      assert meal_preference.fats_in_grams == 42
      assert meal_preference.carbs_in_grams == 42
      assert meal_preference.protein_in_grams == 42
      assert meal_preference.diet_type == "some diet_type"
      assert meal_preference.allergies == ["option1", "option2"]
      assert meal_preference.favorite_foods == ["option1", "option2"]
      assert meal_preference.disliked_foods == ["option1", "option2"]
      assert meal_preference.meal_timing == %{}
      assert meal_preference.water_intake == 120.5
      assert meal_preference.micronutrients == ["option1", "option2"]
      assert meal_preference.special_conditions == "some special_conditions"
      assert meal_preference.activity_level == "some activity_level"
    end

    test "create_meal_preference/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = MealPreferences.create_meal_preference(@invalid_attrs)
    end

    test "update_meal_preference/2 with valid data updates the meal_preference" do
      meal_preference = meal_preference_fixture()
      update_attrs = %{daily_calorie_limit: 43, fats_in_grams: 43, carbs_in_grams: 43, protein_in_grams: 43, diet_type: "some updated diet_type", allergies: ["option1"], favorite_foods: ["option1"], disliked_foods: ["option1"], meal_timing: %{}, water_intake: 456.7, micronutrients: ["option1"], special_conditions: "some updated special_conditions", activity_level: "some updated activity_level"}

      assert {:ok, %MealPreference{} = meal_preference} = MealPreferences.update_meal_preference(meal_preference, update_attrs)
      assert meal_preference.daily_calorie_limit == 43
      assert meal_preference.fats_in_grams == 43
      assert meal_preference.carbs_in_grams == 43
      assert meal_preference.protein_in_grams == 43
      assert meal_preference.diet_type == "some updated diet_type"
      assert meal_preference.allergies == ["option1"]
      assert meal_preference.favorite_foods == ["option1"]
      assert meal_preference.disliked_foods == ["option1"]
      assert meal_preference.meal_timing == %{}
      assert meal_preference.water_intake == 456.7
      assert meal_preference.micronutrients == ["option1"]
      assert meal_preference.special_conditions == "some updated special_conditions"
      assert meal_preference.activity_level == "some updated activity_level"
    end

    test "update_meal_preference/2 with invalid data returns error changeset" do
      meal_preference = meal_preference_fixture()
      assert {:error, %Ecto.Changeset{}} = MealPreferences.update_meal_preference(meal_preference, @invalid_attrs)
      assert meal_preference == MealPreferences.get_meal_preference!(meal_preference.id)
    end

    test "delete_meal_preference/1 deletes the meal_preference" do
      meal_preference = meal_preference_fixture()
      assert {:ok, %MealPreference{}} = MealPreferences.delete_meal_preference(meal_preference)
      assert_raise Ecto.NoResultsError, fn -> MealPreferences.get_meal_preference!(meal_preference.id) end
    end

    test "change_meal_preference/1 returns a meal_preference changeset" do
      meal_preference = meal_preference_fixture()
      assert %Ecto.Changeset{} = MealPreferences.change_meal_preference(meal_preference)
    end
  end
end
