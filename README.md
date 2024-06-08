# meal.
![image](./priv/assets/static/images/meal-logo.png)

> Simple meal planner app built with Elixir and Phoenix

Setup
1. Run an instance of Postgres locally
2. Go into the `config.exs` file and update the database credentials
3. create a `.env` file in the root of the project and add the following:
```sh
# .env
export OPENAI_API_KEY="your_openai_api_key"
```
4. Run `source .env` to load the environment variables
5. Run `mix setup` to install dependencies and setup the database
6. Run `mix phx.server` to start the server

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

