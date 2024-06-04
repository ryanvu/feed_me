defmodule FeedMeWeb.DashboardLive do
  use FeedMeWeb, :live_view
  alias FeedMe.{Profiles}

  def render(assigns) do
    ~H"""
    <h1 class="text-3xl font-bold py-2 border-b-[1px] mb-4">Dashboard</h1>
    <%= if @loading do %>
      <p>Loading...</p>
    <% else %>
      <div class="flex flex-col gap-2">
        <%= if @user_profile do %>
          <h2><%= @user_profile.first_name %>'s Profile</h2>
          <p>Age: <%= @age %></p>
          <.link href={~p"/profile/#{@user_id}"}>
            <.button>Edit Profile</.button>
          </.link>
        <% else %>
          <p>No user profile found.</p>
          <.link href={~p"/profile/#{@user_id}"}>
            <.button>Setup Profile</.button>
          </.link>
        <% end %>
      </div>
    <% end %>
    """
  end

  def mount(_params, _session, socket) do
    current_user = socket.assigns[:current_user]

    # Initialize loading state
    socket =
      socket
      |> assign(:user_profile, nil)
      |> assign(:user_id, current_user.id)
      |> assign(:age, nil)
      |> assign(:loading, true)

    if connected?(socket) do
      # Load profile
      profile = Profiles.get_profile_by_user_id(current_user.id)

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
