# meal. (WIP)
<img src="https://github.com/ryanvu/feed_me/assets/13227428/27eb4dee-b533-4744-925f-aa1ec7c9cf0e" height="200"/>

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

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## MVP Screenshots
> **Home Page**
<img src="https://github.com/ryanvu/feed_me/assets/13227428/0304feca-2dbe-433f-b2d6-fe5144c5febe" />

> **Meal Generator**
<img src="https://github.com/ryanvu/feed_me/assets/13227428/475989a9-5492-45e6-b35a-b12461289a7b" />
