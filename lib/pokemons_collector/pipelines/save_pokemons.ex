defmodule PokemonsCollector.Pipelines.SavePokemons do
  @behaviour Crawly.Pipeline

  @impl Crawly.Pipeline
  def run(item, state, _opts \\ []) do
    :ok = PokemonsCollector.Worker.add_pokemon(item)

    {item, state}
  end
end
