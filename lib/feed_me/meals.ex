defmodule FeedMe.Meals do
  @moduledoc """
  The Meals context.
  """

  import Ecto.Query, warn: false
  alias FeedMe.Repo

  alias FeedMe.Meals.SavedMeals

  @doc """
  Returns the list of saved_meals.

  ## Examples

      iex> list_saved_meals()
      [%SavedMeals{}, ...]

  """
  def list_saved_meals do
    Repo.all(SavedMeals)
  end

  @doc """
  Gets a single saved_meals.

  Raises `Ecto.NoResultsError` if the Saved meals does not exist.

  ## Examples

      iex> get_saved_meals!(123)
      %SavedMeals{}

      iex> get_saved_meals!(456)
      ** (Ecto.NoResultsError)

  """
  def get_saved_meals!(id), do: Repo.get!(SavedMeals, id)

  @doc """
  Creates a saved_meals.

  ## Examples

      iex> create_saved_meals(%{field: value})
      {:ok, %SavedMeals{}}

      iex> create_saved_meals(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_saved_meals(attrs \\ %{}) do
    %SavedMeals{}
    |> SavedMeals.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a saved_meals.

  ## Examples

      iex> update_saved_meals(saved_meals, %{field: new_value})
      {:ok, %SavedMeals{}}

      iex> update_saved_meals(saved_meals, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_saved_meals(%SavedMeals{} = saved_meals, attrs) do
    saved_meals
    |> SavedMeals.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a saved_meals.

  ## Examples

      iex> delete_saved_meals(saved_meals)
      {:ok, %SavedMeals{}}

      iex> delete_saved_meals(saved_meals)
      {:error, %Ecto.Changeset{}}

  """
  def delete_saved_meals(%SavedMeals{} = saved_meals) do
    Repo.delete(saved_meals)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking saved_meals changes.

  ## Examples

      iex> change_saved_meals(saved_meals)
      %Ecto.Changeset{data: %SavedMeals{}}

  """
  def change_saved_meals(%SavedMeals{} = saved_meals, attrs \\ %{}) do
    SavedMeals.changeset(saved_meals, attrs)
  end
end
