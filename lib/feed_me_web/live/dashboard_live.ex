defmodule FeedMeWeb.DashboardLive do
  use FeedMeWeb, :live_view
  alias FeedMe.{Profiles}

  def render(assigns) do
    ~H"""
    <h1 class="text-3xl font-bold py-2 border-b-[1px] mb-4">Dashboard</h1>
    <div class="flex flex-col gap-2">
      <%= if @user_profile do %>
        <h2><%= @user_profile.first_name %>'s Profile</h2>
        <p>Age: <%= @user_profile.date_of_birth %></p>
      <% else %>
        <p>No user profile found.</p>
        <.link href={~p"/profile"}>
          <.button>Setup Profile</.button>
        </.link>
      <% end %>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    current_user = socket.assigns[:current_user]

    if connected?(socket) do
      case Profiles.get_profile_by_user_id(current_user.id) do
        nil ->
          {:ok, socket |> assign(:user_profile, nil)}

        user_profile ->
          {:ok, assign(socket, :user_profile, user_profile)}
      end
    else
      {:ok, socket |> assign(:user_profile, nil)}
    end
  end
end
