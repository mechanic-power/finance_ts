# FinanceTS (Finance TimeSeries for Elixir)

FinanceTS for Elixir allows you to access free and paid finance apis to query time series data in JSON and CSV. And it’s easy to roll your own adapter.

* Installation instructions (internal link)
* Hex documentation (external link)

## Why?

Usually no (affordable) finance api gives you access to all the time series data you’ll need. Even if an api supports most exchanges and stocks, what about e.g. gold prices? Time series data allows for an easy abstraction.

You deal with a timestamp, some prices and often the volume. That’s what this library does. Install the hex package and time series data in the format you need.

## What

## How

### Installation & Usage

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `finance_ts` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:finance_ts, "~> 0.1.0"}
  ]
end
```

### Creating your own adapter

FinanceTS contains a generator for adapter scaffolding. Use the following steps to get started:

1. Create a new adapter with: mix financets.gen.adapter AdapterName
2. Collect all the endpoints you need for the api
3. Download sample data from your api and save them in the support created support directory. Which one should you download? Look at other adapters. Good candidates are: Responses with no data. Responses with data in different resolutions.

## Discussion

This api only focuses on time series data. I know that a lot of apis support fetching additional data like company profiles, outstanding shares and so on. The data these apis can deliver varies greatly. To keep this library maintainable and extensible, it will only ever support time series data. This may include websocket endpoints in the future as well.
