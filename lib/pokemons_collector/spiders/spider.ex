defmodule PokemonsCollector.Spider do
  use Crawly.Spider

  @base_url "https://scrapeme.live/shop/"

  @impl Crawly.Spider
  def base_url(), do: @base_url

  @impl Crawly.Spider
  def init() do
    [start_urls: [@base_url]]
  end

  @impl Crawly.Spider
  def parse_item(response) do
    {:ok, document} = Floki.parse_document(response.body)

    items = PokemonsCollector.ItemParser.parse(document)

    next_requests =
      document
      |> Floki.find(".page-numbers")
      |> Floki.attribute("href")
      |> Enum.map(fn url ->
        Crawly.Utils.build_absolute_url(url, response.request.url)
        |> Crawly.Utils.request_from_url()
      end)

    %{items: items, requests: next_requests}
  end
end
