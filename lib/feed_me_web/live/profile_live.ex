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

  def mount(_, _, socket) do
    socket =
      assign(
        socket,
        form: to_form(Profiles.change_profile(%Profile{}))
      )

    {:ok, socket}
  end

  def handle_event("submit", %{"profile" => params}, socket) do
    case Profiles.create_profile(socket.assigns.current_user, params) do
      {:ok, _profile} ->
        changeset = Profiles.change_profile(%Profile{})

        socket =
          socket
          |> put_flash(:info, ~c"Profile created")
          |> assign(:form, to_form(changeset))

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end
end
