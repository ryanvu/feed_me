defmodule FeedMe.MealPreferences do
  @moduledoc """
  The MealPreferences context.
  """

  import Ecto.Query, warn: false
  alias FeedMe.Repo

  alias FeedMe.MealPreferences.MealPreference

  @doc """
  Returns the list of meal_preferences.

  ## Examples

      iex> list_meal_preferences()
      [%MealPreference{}, ...]

  """
  def list_meal_preferences do
    Repo.all(MealPreference)
  end

  @doc """
  Retrieves the meal preference for a specific user based on their user ID.
  ## Parameters
  - user_id: The unique identifier of the user whose meal preference is being retrieved.
  ## Returns
  Returns the meal preference record for the specified user ID if found, or nil if no record is found.
  ## Raises
  No specific errors are raised by this function.
  ## Examples
      iex> get_meal_preference_by_user_id(123)
      %MealPreference{user_id: 123, preference: "Vegetarian", ...}

  """
  def get_meal_preference_by_user_id(user_id) do
    Repo.one(
      from m in MealPreference,
        where: m.user_id == ^user_id
    )
  end

  @doc """
  Gets a single meal_preference.

  Raises `Ecto.NoResultsError` if the Meal preference does not exist.

  ## Examples

      iex> get_meal_preference!(123)
      %MealPreference{}

      iex> get_meal_preference!(456)
      ** (Ecto.NoResultsError)

  """
  def get_meal_preference!(id), do: Repo.get!(MealPreference, id)

  # @doc """
  # Creates a new meal preference for a given user.
  # ## Parameters:
  # - user (User): The user for whom the meal preference is being created.
  # - attrs (map): Optional. Additional attributes for the meal preference.
  # ## Raises:
  # - Ecto.MultiError: If there are errors during the transaction.
  # ## Example:
  #     create_meal_preference(user, %{meal_type: "Breakfast", cuisine: "Italian"})
  # """

  def create_meal_preference(user, attrs \\ {}) do
    user
    |> Ecto.build_assoc(:meal_preferences)
    |> MealPreference.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a meal_preference.

  ## Examples

      iex> update_meal_preference(meal_preference, %{field: new_value})
      {:ok, %MealPreference{}}

      iex> update_meal_preference(meal_preference, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_meal_preference(%MealPreference{} = meal_preference, attrs) do
    meal_preference
    |> MealPreference.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a meal_preference.

  ## Examples

      iex> delete_meal_preference(meal_preference)
      {:ok, %MealPreference{}}

      iex> delete_meal_preference(meal_preference)
      {:error, %Ecto.Changeset{}}

  """
  def delete_meal_preference(%MealPreference{} = meal_preference) do
    Repo.delete(meal_preference)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking meal_preference changes.

  ## Examples

      iex> change_meal_preference(meal_preference)
      %Ecto.Changeset{data: %MealPreference{}}

  """
  def change_meal_preference(%MealPreference{} = meal_preference, attrs \\ %{}) do
    MealPreference.changeset(meal_preference, attrs)
  end
end
