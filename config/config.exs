import Config

config :crawly,
  closespider_timeout: 10,
  concurrent_requests_per_domain: 5,
  follow_redirects: false,
  closespider_itemcount: 3000,
  output_format: "json",
  item: [:id, :name, :price, :sku, :image_url],
  item_id: :id,
  # middlewares: [
  #   Crawly.Middlewares.DomainFilter,
  #   Crawly.Middlewares.UniqueRequest,
  #   Crawly.Middlewares.UserAgent
  # ],
  pipelines: [
    {Crawly.Pipelines.Validate, fields: [:id, :name, :price, :sku, :image_url]},
    {Crawly.Pipelines.DuplicatesFilter, item_id: :id},
    Crawly.Pipelines.JSONEncoder,
    {Crawly.Pipelines.WriteToFile, folder: "./", extension: "json"},
    PokemonsCollector.Pipelines.SavePokemons
  ]
