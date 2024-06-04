defmodule FeedMeWeb.DashboardLive do
  use FeedMeWeb, :live_view
  alias FeedMe.{Profiles, MealPreferences}

  def render(assigns) do
    ~H"""
    <h1 class="text-3xl font-bold py-2 border-b-[1px] mb-4">Dashboard</h1>
    <%= if @loading do %>
      <p>Loading...</p>
    <% else %>
      <div class="flex flex-col gap-2 mb-4">
        <%= if @user_profile do %>
          <div class="flex justify-between">
            <div class="flex w-48 h-48 rounded border">
              <img class="object-cover" src={@user_profile.profile_picture_url} alt="" />
            </div>
            <div class="flex flex-col items-end">
              <h2 class="text-2xl font-bold">
                <%= @user_profile.first_name %> <%= @user_profile.last_name %>
              </h2>
              <p><span class="font-bold">Weight:</span> <%= @user_profile.weight %></p>
              <p><span class="font-bold">Height:</span> <%= @user_profile.height %></p>
              <p><span class="font-bold">Age:</span> <%= @age %></p>
              <.link class="mt-auto" href={~p"/profile/#{@user_id}"}>
                <.button>Edit Profile</.button>
              </.link>
            </div>
          </div>
        <% else %>
          <p>No user profile found.</p>
          <.link href={~p"/profile/#{@user_id}"}>
            <.button>Setup Profile</.button>
          </.link>
        <% end %>
      </div>

      <h2 class="text-lg italic py-[2px] border-b-[1px]">Preferences</h2>
      <%= if @meal_preferences do %>
        <div class="flex justify-between py-2">
          <div class="flex flex-col">
            <p>
              <span class="font-bold">Calories:</span> <%= @meal_preferences.daily_calorie_limit %>kcal
            </p>
            <p>
              <span class="font-bold">Carbs:</span> <%= @meal_preferences.carbs_in_grams %>g
            </p>
            <p>
              <span class="font-bold">Fats:</span> <%= @meal_preferences.fats_in_grams %>g
            </p>
            <p>
              <span class="font-bold">Protein:</span> <%= @meal_preferences.protein_in_grams %>g
            </p>
          </div>

          <.link href={~p"/preferences/#{@user_id}"} class="mt-auto">
            <.button>Edit Preferences</.button>
          </.link>
        </div>
      <% else %>
        <.link href={~p"/preferences/#{@user_id}"}>
          <.button>Setup Preferences</.button>
        </.link>
      <% end %>
    <% end %>
    """
  end

  def mount(_params, _session, socket) do
    current_user = socket.assigns[:current_user]

    # Initialize loading state
    socket =
      socket
      |> assign(:user_id, current_user.id)
      |> assign(:loading, true)

    if connected?(socket) do
      # Load profile
      profile = Profiles.get_profile_by_user_id(current_user.id)
      meal_preferences = MealPreferences.get_meal_preference_by_user_id(current_user.id)

      # Assign profile data to socket
      socket =
        case profile do
          nil ->
            socket
            |> assign(:user_profile, nil)
            |> assign(:age, nil)

          user_profile ->
            age = calculate_age(user_profile.date_of_birth)

            socket
            |> assign(:user_profile, user_profile)
            |> assign(:age, age)
        end

      socket =
        case meal_preferences do
          nil ->
            socket
            |> assign(:meal_preferences, nil)

          preference_exists ->
            socket
            |> assign(:meal_preferences, preference_exists)
        end

      # Set loading to false after fetching data
      socket = assign(socket, :loading, false)

      {:ok, socket}
    else
      {:ok, socket}
    end
  end

  defp calculate_age(nil), do: nil

  defp calculate_age(date_of_birth) do
    current_date = Date.utc_today()
    years = Date.diff(current_date, date_of_birth) |> div(365)
    years
  end
end
