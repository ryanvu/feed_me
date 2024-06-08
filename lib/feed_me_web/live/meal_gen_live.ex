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
      <.button phx-click="generate_meal" class="mb-2">Generate Meal</.button>
    <% end %>
    <%= if @meal_plan do %>
      <%= if @meal_plan.loading do %>
        <p>Generating meal</p>
      <% else %>
        <%= if @meal_plan.ok? do %>
          <%= for {meal, index} <- @meal_plan.result["meal_plan"] |> Enum.with_index() do %>
            <div class="border-[1px] flex flex-col p-4 mb-4">
              <div class="flex justify-between items-center">
                <p class="font-bold text-lg"><%= meal["name"] %></p>
                <.icon name="hero-heart" class="w-6 h-6 text-red-500 cursor-pointer" />
              </div>
              <div class="flex justify-between">
                <div class="flex flex-col">
                  <p class="text-sm"><%= determine_meal_time_view(meal["meal_time"])["title"] %></p>
                  <ul>
                    <%= for ingredient <- meal["ingredients"] do %>
                      <li>
                        <%= ingredient["name"] %> - <%= ingredient["amount_in_grams"] %>g - <%= ingredient[
                          "total_calories_of_ingredient"
                        ] %>kcal
                      </li>
                    <% end %>
                  </ul>
                </div>
                <div class="flex flex-col text-xs gap-2">
                  <p class="rounded-full px-2 text-orange-950 bg-orange-300">
                    Calories: <%= meal["total_calories"] %>kcal
                  </p>
                  <p class="rounded-full px-2 text-lime-800 bg-lime-300">
                    Carbs: <%= meal["total_carbs_in_grams"] %>g
                  </p>
                  <p class="rounded-full px-2 text-amber-800 bg-amber-300">
                    Fats: <%= meal["total_fats_in_grams"] %>g
                  </p>
                  <p class="rounded-full px-2 text-rose-900 bg-rose-300">
                    Protein: <%= meal["total_protein_in_grams"] %>g
                  </p>
                </div>
              </div>
            </div>
          <% end %>
        <% else %>
          <p>Failed to generate meal</p>
        <% end %>
      <% end %>
    <% end %>
    """
  end

  @impl true
  def mount(_, _, socket) do
    if connected?(socket) do
      preferences = MealPreferences.get_meal_preference_by_user_id(socket.assigns.current_user.id)

      socket =
        socket
        |> assign(preferences: preferences, loading: false, meal_plan: nil)

      {:ok, socket}
    else
      {:ok, assign(socket, loading: true)}
    end
  end

  @impl true
  def handle_event("generate_meal", _params, socket) do
    # Generate meal

    preference_json =
      socket.assigns.preferences
      |> Jason.encode!()

    {:noreply,
     assign_async(socket, :meal_plan, fn ->
       {:ok, %{meal_plan: generate_meal(preference_json)}}
     end)}
  end

  def determine_meal_time_view(meal_time) do
    case meal_time do
      "breakfast" -> %{ "title" => "Breakfast", "class" => "bg-yellow-100 text-yellow-900"}
      "lunch" -> %{ "title" => "Lunch", "class" => "bg-green-100 text-green-900"}
      "dinner" -> %{ "title" => "Dinner", "class" => "bg-blue-100 text-white"}
      "snacks" -> %{ "title" => "Snacks", "class" => "bg-pink-100 text-pink-900"}
    end
  end

  defp generate_meal(preference_json) do
    case Openai.request(preference_json) do
      {:ok, response} ->
        response
        |> Map.get("choices")
        |> Enum.at(0)
        |> Map.get("message")
        |> Map.get("content")
        |> Jason.decode!()

      {:error, error} ->
        error
    end
  end
end
