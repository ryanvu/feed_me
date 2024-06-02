defmodule FeedMeWeb.ProfileLive do
  use FeedMeWeb, :live_view
  alias FeedMe.{Profiles, Profiles.Profile}

  def render(assigns) do
    ~H"""
    <h1 class="text-3xl font-bold py-2 border-b-[1px] mb-4">Profile</h1>
    <.form for={@form} class="flex flex-col gap-2" phx-submit="submit">
      <.input field={@form[:first_name]} label="First name" type="text" />
      <.input field={@form[:last_name]} label="Last name" type="text" />
      <.input field={@form[:date_of_birth]} label="Date of birth" type="date" />
      <.input field={@form[:height]} label="Height" type="number" />
      <.input field={@form[:weight]} label="Weight" type="number" />
      <.button>Update Profile</.button>
    </.form>
    """
  end

  def mount(params, _, socket) do
    %{"user_id" => user_id} = params

    profile =
      case Profiles.get_profile_by_user_id(user_id) do
        nil -> %Profile{}
        profile -> profile
      end

    changeset =
      case profile do
        nil -> Profiles.change_profile(%Profile{})
        profile -> Profiles.change_profile(profile)
      end

    socket =
      socket
      |> assign(form: to_form(changeset))
      |> assign(:profile, profile)

    {:ok, socket}
  end

  def handle_event("submit", %{"profile" => params}, socket) do
    profile = socket.assigns.profile

    result =
      case profile do
        nil ->
          Profiles.create_profile(socket.assigns.current_user, params)

        _ ->
          Profiles.update_profile(profile, params)
      end

    case result do
      {:ok, profile} ->
        changeset = Profiles.change_profile(profile || %Profile{})

        socket =
          socket
          |> put_flash(:info, "Profile #{if profile, do: "updated", else: "created"}")
          |> assign(:form, to_form(changeset))
          |> assign(:profile, profile)

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end
end
