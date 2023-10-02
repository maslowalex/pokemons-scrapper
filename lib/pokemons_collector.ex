defmodule PokemonsCollector do
  @moduledoc """
  Documentation for `PokemonsCollector`.
  """

  alias PokemonsCollector.Spider

  def start do
    Crawly.Engine.start_spider(Spider)
  end
end
