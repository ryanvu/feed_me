defmodule FeedMe.ProfilesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FeedMe.Profiles` context.
  """

  @doc """
  Generate a profile.
  """
  def profile_fixture(attrs \\ %{}) do
    {:ok, profile} =
      attrs
      |> Enum.into(%{
        bio: "some bio",
        date_of_birth: ~D[2024-06-01],
        first_name: "some first_name",
        height: 42,
        last_name: "some last_name",
        profile_picture_url: "some profile_picture_url",
        weight: 42
      })
      |> FeedMe.Profiles.create_profile()

    profile
  end
end
