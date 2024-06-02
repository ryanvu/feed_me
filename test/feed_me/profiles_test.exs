defmodule FeedMe.ProfilesTest do
  use FeedMe.DataCase

  alias FeedMe.Profiles

  describe "profile" do
    alias FeedMe.Profiles.Profile

    import FeedMe.ProfilesFixtures

    @invalid_attrs %{bio: nil, profile_picture_url: nil, first_name: nil, last_name: nil, weight: nil, height: nil, date_of_birth: nil}

    test "list_profile/0 returns all profile" do
      profile = profile_fixture()
      assert Profiles.list_profile() == [profile]
    end

    test "get_profile!/1 returns the profile with given id" do
      profile = profile_fixture()
      assert Profiles.get_profile!(profile.id) == profile
    end

    test "create_profile/1 with valid data creates a profile" do
      valid_attrs = %{bio: "some bio", profile_picture_url: "some profile_picture_url", first_name: "some first_name", last_name: "some last_name", weight: 42, height: 42, date_of_birth: ~D[2024-06-01]}

      assert {:ok, %Profile{} = profile} = Profiles.create_profile(valid_attrs)
      assert profile.bio == "some bio"
      assert profile.profile_picture_url == "some profile_picture_url"
      assert profile.first_name == "some first_name"
      assert profile.last_name == "some last_name"
      assert profile.weight == 42
      assert profile.height == 42
      assert profile.date_of_birth == ~D[2024-06-01]
    end

    test "create_profile/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Profiles.create_profile(@invalid_attrs)
    end

    test "update_profile/2 with valid data updates the profile" do
      profile = profile_fixture()
      update_attrs = %{bio: "some updated bio", profile_picture_url: "some updated profile_picture_url", first_name: "some updated first_name", last_name: "some updated last_name", weight: 43, height: 43, date_of_birth: ~D[2024-06-02]}

      assert {:ok, %Profile{} = profile} = Profiles.update_profile(profile, update_attrs)
      assert profile.bio == "some updated bio"
      assert profile.profile_picture_url == "some updated profile_picture_url"
      assert profile.first_name == "some updated first_name"
      assert profile.last_name == "some updated last_name"
      assert profile.weight == 43
      assert profile.height == 43
      assert profile.date_of_birth == ~D[2024-06-02]
    end

    test "update_profile/2 with invalid data returns error changeset" do
      profile = profile_fixture()
      assert {:error, %Ecto.Changeset{}} = Profiles.update_profile(profile, @invalid_attrs)
      assert profile == Profiles.get_profile!(profile.id)
    end

    test "delete_profile/1 deletes the profile" do
      profile = profile_fixture()
      assert {:ok, %Profile{}} = Profiles.delete_profile(profile)
      assert_raise Ecto.NoResultsError, fn -> Profiles.get_profile!(profile.id) end
    end

    test "change_profile/1 returns a profile changeset" do
      profile = profile_fixture()
      assert %Ecto.Changeset{} = Profiles.change_profile(profile)
    end
  end
end
