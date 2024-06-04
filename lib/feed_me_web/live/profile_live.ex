defmodule FeedMeWeb.ProfileLive do
  use FeedMeWeb, :live_view
  alias FeedMe.{Profiles, Profiles.Profile}

  @impl true
  def render(assigns) do
    ~H"""
    <h1 class="text-3xl font-bold py-2 border-b-[1px] mb-4">Profile</h1>

    <%= if(@profile.profile_picture_url) do %>
      <div class="flex w-48 h-48 mb-2 border rounded">
        <img
          class="object-cover"
          src={@profile.profile_picture_url}
          alt={"Profile Image for #{@profile.first_name}"}
        />
      </div>
    <% end %>

    <.simple_form for={@form} class="flex flex-col gap-2" phx-submit="submit" phx-change="validate">
      <.live_file_input upload={@uploads.image} />
      <.input field={@form[:first_name]} label="First name" type="text" />
      <.input field={@form[:last_name]} label="Last name" type="text" />
      <.input field={@form[:date_of_birth]} label="Date of birth" type="date" />
      <.input field={@form[:height]} label="Height" type="number" />
      <.input field={@form[:weight]} label="Weight" type="number" />
      <.button>Update Profile</.button>
    </.simple_form>
    """
  end

  @impl true
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
      |> allow_upload(:image, accept: ~w(.png .jpg), max_entries: 1)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", _, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("submit", %{"profile" => profile_params}, socket) do
    profile = socket.assigns.profile

    uploaded_files = consume_files(socket)

    profile_params =
      if uploaded_files != [] do
        Map.put(profile_params, "profile_picture_url", List.first(uploaded_files))
      else
        profile_params
      end

    result =
      case profile do
        nil ->
          Profiles.create_profile(socket.assigns.current_user, profile_params)

        _ ->
          Profiles.update_profile(profile, profile_params)
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

  defp consume_files(socket) do
    consume_uploaded_entries(socket, :image, fn %{path: path}, _entry ->
      dest = Path.join(Application.app_dir(:feed_me, "priv/static/uploads"), Path.basename(path))
      File.cp!(path, dest)
      {:ok, ~p"/uploads/#{Path.basename(dest)}"}
    end)
  end
end
