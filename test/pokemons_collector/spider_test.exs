defmodule PokemonsCollector.ItemsParserTest do
  use ExUnit.Case, async: true

  alias PokemonsCollector.ItemParser

  @html File.read!("test/fixtures/pokemons.html")

  describe "parse/1" do
    setup do
      {:ok, document} = Floki.parse_document(@html)

      %{doc: document}
    end

    test "collects all pokemons from the single page", %{doc: document} do
      items = ItemParser.parse(document)

      assert length(items) == 16
    end

    test "all items have an id integer attribute", %{doc: document} do
      items = ItemParser.parse(document)

      assert Enum.all?(items, fn item -> is_integer(item.id) end)
    end

    test "all items have expected set of attributes", %{doc: document} do
      items = ItemParser.parse(document)

      assert Enum.all?(items, fn item ->
               item |> Map.keys() |> Enum.sort() == [:id, :image_url, :name, :price, :sku]
             end)
    end
  end
end
