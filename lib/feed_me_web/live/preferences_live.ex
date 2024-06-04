defmodule FeedMeWeb.PreferencesLive do
  use FeedMeWeb, :live_view

  alias FeedMe.{MealPreferences, MealPreferences.MealPreference}

  @impl true
  def render(assigns) do
    ~H"""
    <h1 class="text-3xl font-bold py-2 border-b-[1px]">Meal Preferences</h1>
    <.simple_form for={@form} phx-change="validate" phx-submit="submit">
      <h2 class="mb-2 italic">Calories + Macros</h2>
      <.input
        type="number"
        min="1200"
        max="10000"
        field={@form[:daily_calorie_limit]}
        label="Calorie Limit (kcal)"
        placeholder="e.g. 1200 kcal"
        required
      />
      <.input
        type="number"
        min="0"
        max="100"
        field={@form[:fats_in_grams]}
        label="Fats (g)"
        placeholder="e.g. 40g fats"
        required
      />
      <.input
        type="number"
        min="0"
        max="600"
        field={@form[:carbs_in_grams]}
        label="Carbohydrates (g)"
        placeholder="e.g. 160g carbs"
        required
      />
      <.input
        type="number"
        min="100"
        max="400"
        field={@form[:protein_in_grams]}
        label="Protein (g)"
        placeholder="e.g. 200g protein"
        required
      />
      <.button>Save</.button>
    </.simple_form>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    %{"user_id" => user_id} = params
    meal_preference = MealPreferences.get_meal_preference_by_user_id(user_id)
    changeset = MealPreferences.change_meal_preference(meal_preference || %MealPreference{})

    socket =
      socket
      |> assign(form: to_form(changeset))
      |> assign(:meal_preference, meal_preference)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", _, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("submit", %{"meal_preference" => meal_preference_params}, socket) do
    meal_preference = socket.assigns.meal_preference

    result =
      case meal_preference do
        nil ->
          MealPreferences.create_meal_preference(
            socket.assigns.current_user,
            meal_preference_params
          )

        %MealPreference{id: nil} ->
          MealPreferences.create_meal_preference(
            socket.assigns.current_user,
            meal_preference_params
          )

        _ ->
          MealPreferences.update_meal_preference(meal_preference, meal_preference_params)
      end

    case result do
      {:ok, meal_preference} ->
        changeset = MealPreferences.change_meal_preference(meal_preference)

        socket =
          socket
          |> put_flash(
            :info,
            "Preferences #{if socket.assigns.meal_preference, do: "updated", else: "created"}"
          )
          |> assign(:form, to_form(changeset))
          |> assign(:meal_preference, meal_preference)

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end
end
