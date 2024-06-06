defmodule FeedMeWeb.MealGenLive do
  use FeedMeWeb, :live_view

  alias FeedMe.MealPreferences
  alias FeedMe.OpenAi.Openai

  @impl true
  def render(%{loading: true} = assigns) do
    ~H"""
    Loading...
    """
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1 class="text-3xl font-bold py-2 border-b-[1px] mb-4">Meal Generator</h1>
    <%= if @preferences do %>
      <div class="flex flex-col gap-2 mb-4">
        <div class="flex justify-between">
          <div class="flex flex-col">
            <p>
              <span class="font-bold">Calories:</span> <%= @preferences.daily_calorie_limit %>kcal
            </p>
            <p>
              <span class="font-bold">Carbs:</span> <%= @preferences.carbs_in_grams %>g
            </p>
            <p>
              <span class="font-bold">Fats:</span> <%= @preferences.fats_in_grams %>g
            </p>
            <p>
              <span class="font-bold">Protein:</span> <%= @preferences.protein_in_grams %>g
            </p>
          </div>
        </div>
      </div>
      <.button phx-click="generate_meal">Generate Meal</.button>
    <% end %>
    <%= if @result do %>
      <p>{@result}</p>
    <% end %>
    """
  end

  @impl true
  def mount(_, _, socket) do
    if connected?(socket) do
      preferences = MealPreferences.get_meal_preference_by_user_id(socket.assigns.current_user.id)

      socket =
        socket
        |> assign(preferences: preferences, loading: false, result: nil)

      {:ok, socket}
    else
      {:ok, assign(socket, loading: true)}
    end
  end

  @impl true
  def handle_event("generate_meal", _params, socket) do
    # Generate meal
    preference_json = socket.assigns.preferences |> Jason.encode!()
    result = 
      case Openai.request(preference_json) do
        {:ok, response} -> 
          response
          |> Map.get("choices")
          |> Enum.at(0)
          |> Map.get("message")
          |> Map.get("content")
          |> Jason.decode!()

        {:error, error} -> error
      end 


    IO.inspect(result, label: "OpenAI Res")
    {:noreply, assign(socket, result: result)}
  end
end
