defmodule FeedMe.OpenAi.Openai do
  @base_url "https://api.openai.com/v1/chat"
  @api_key Application.get_env(:feed_me, FeedMe.OpenAi.Openai)[:api_key]

  # @context """
  # You are an expert dietician nutritionist. You are helping a client with generating meal plans based off of their incoming preferences.
  # Return json object format should be:
  # {
  #   meal_plan: [meal1, meal2, meal3, etc],
  #   total_calories,
  #   total_fats_in_grams,
  #   total_protein_in_grams,
  #   total_carbs_in_grams
  # }
  # where each meal is a json object with the following format:
  # {
  #   name,
  #   calories,
  #   fats_in_grams,
  #   protein_in_grams,
  #   carbs_in_grams,
  #   recipe
  # }
  # where recipe is a json object of each ingredient, and their respective amounts in grams:
  # {
  #   ingredient1: amount_in_grams, total_calories_of_ingredient,
  #   ingredient2: amount_in_grams, total_calories_of_ingredient
  # }
  # """

  # @context """
  # You are a helpful assistant that generates meal plans.
  # Please provide a detailed meal plan for the week. The response should be in the following JSON format:
  # {
  #   meal_plan: [meal1, meal2, meal3, ...],
  #   total_calories: total_calories_value,
  #   total_fats_in_grams: total_fats_value,
  #   total_protein_in_grams: total_protein_value,
  #   total_carbs_in_grams: total_carbs_value
  # } Substitute meal1, meal2, meal3, etc., with the actual meal details and replace the placeholder values with the corresponding calculated totals.
  # """

  def request(preferences) do
    url = "#{@base_url}/completions"

    headers = [
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{@api_key}"}
    ]

    prompt =
      "return a meal plan for a client based off of their preferences: #{preferences} in json format: {meal_plan: [breakfast, lunch, dinner, snacks], total_calories, total_fats_in_grams, total_protein_in_grams, total_carbs_in_grams} in each meal, include each ingredient and their respective amounts in grams"


    IO.inspect(prompt, label: "prompt")

    body =
      Jason.encode!(%{
        model: "gpt-3.5-turbo",
        messages: [
          %{
            role: "assistant",
            content:
              "You are an expert nutrionist with the most up to date knowledge on meal planning and nutrition facts on any food item."
          },
          %{role: "user", content: prompt}
        ],
        max_tokens: 1000,
        response_format: %{type: "json_object"}
      })

    options = [timeout: 30_000, recv_timeout: 30_000]

    case HTTPoison.post(url, body, headers, options) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Jason.decode!(body)}

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        {:error, %{status_code: status_code, body: body}}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
