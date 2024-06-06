defmodule FeedMe.OpenAi.Openai do
  @base_url "https://api.openai.com/v1/chat"
  @api_key Application.get_env(:feed_me, FeedMe.OpenAi.Openai)[:api_key]
  @json_format """
  {
    "meal_plan": <an array of meals>[],
    "total_calories": <total_calories_of_meal_plan>,
    "total_fats_in_grams": <total_fats_in_grams>,
    "total_protein_in_grams": <total_protein_in_grams>,
    "total_carbs_in_grams": <total_carbs_in_grams>
  }
  where each meal recipe is a json object:
  meal = {
    "name": <meal_name>,
    "meal_time": <breakfast | lunch | dinner | snacks>,
    "ingredients": <an array of ingredients>[],
  }
  where each ingredient is a json object of the ingredient and their respective amounts in grams:
  ingredient = {
    "name": <ingredient_name>,
    "amount_in_grams": <amount_in_grams>,
    "total_calories_of_ingredient": <total_calories_of_ingredient>
  }
  """

  def request(preferences) do
    url = "#{@base_url}/completions"

    headers = [
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{@api_key}"}
    ]

    prompt =
      "Create a meal plan for a client that reaches the requirements of their preferences: #{preferences}"

    IO.inspect(prompt, label: "prompt")

    body =
      Jason.encode!(%{
        model: "gpt-3.5-turbo",
        messages: [
          %{
            role: "system",
            content:
              "You are a helpful assistant that generates meal plans. Respond with a JSON structure: #{@json_format}"
          },
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
