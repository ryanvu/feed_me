defmodule FeedMe.MealsTest do
  use FeedMe.DataCase

  alias FeedMe.Meals

  describe "saved_meals" do
    alias FeedMe.Meals.SavedMeals

    import FeedMe.MealsFixtures

    @invalid_attrs %{name: nil, meal_time: nil, ingredients: nil, total_calories: nil, total_fats_in_grams: nil, total_protein_in_grams: nil, total_carbs_in_grams: nil}

    test "list_saved_meals/0 returns all saved_meals" do
      saved_meals = saved_meals_fixture()
      assert Meals.list_saved_meals() == [saved_meals]
    end

    test "get_saved_meals!/1 returns the saved_meals with given id" do
      saved_meals = saved_meals_fixture()
      assert Meals.get_saved_meals!(saved_meals.id) == saved_meals
    end

    test "create_saved_meals/1 with valid data creates a saved_meals" do
      valid_attrs = %{name: "some name", meal_time: "some meal_time", ingredients: %{}, total_calories: 42, total_fats_in_grams: 42, total_protein_in_grams: 42, total_carbs_in_grams: 42}

      assert {:ok, %SavedMeals{} = saved_meals} = Meals.create_saved_meals(valid_attrs)
      assert saved_meals.name == "some name"
      assert saved_meals.meal_time == "some meal_time"
      assert saved_meals.ingredients == %{}
      assert saved_meals.total_calories == 42
      assert saved_meals.total_fats_in_grams == 42
      assert saved_meals.total_protein_in_grams == 42
      assert saved_meals.total_carbs_in_grams == 42
    end

    test "create_saved_meals/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Meals.create_saved_meals(@invalid_attrs)
    end

    test "update_saved_meals/2 with valid data updates the saved_meals" do
      saved_meals = saved_meals_fixture()
      update_attrs = %{name: "some updated name", meal_time: "some updated meal_time", ingredients: %{}, total_calories: 43, total_fats_in_grams: 43, total_protein_in_grams: 43, total_carbs_in_grams: 43}

      assert {:ok, %SavedMeals{} = saved_meals} = Meals.update_saved_meals(saved_meals, update_attrs)
      assert saved_meals.name == "some updated name"
      assert saved_meals.meal_time == "some updated meal_time"
      assert saved_meals.ingredients == %{}
      assert saved_meals.total_calories == 43
      assert saved_meals.total_fats_in_grams == 43
      assert saved_meals.total_protein_in_grams == 43
      assert saved_meals.total_carbs_in_grams == 43
    end

    test "update_saved_meals/2 with invalid data returns error changeset" do
      saved_meals = saved_meals_fixture()
      assert {:error, %Ecto.Changeset{}} = Meals.update_saved_meals(saved_meals, @invalid_attrs)
      assert saved_meals == Meals.get_saved_meals!(saved_meals.id)
    end

    test "delete_saved_meals/1 deletes the saved_meals" do
      saved_meals = saved_meals_fixture()
      assert {:ok, %SavedMeals{}} = Meals.delete_saved_meals(saved_meals)
      assert_raise Ecto.NoResultsError, fn -> Meals.get_saved_meals!(saved_meals.id) end
    end

    test "change_saved_meals/1 returns a saved_meals changeset" do
      saved_meals = saved_meals_fixture()
      assert %Ecto.Changeset{} = Meals.change_saved_meals(saved_meals)
    end
  end
end
