defmodule PokemonsCollector.ItemParser do
  @spec parse(Floki.html_tree()) :: [map()]
  def parse(html_tree) do
    html_tree
    |> Floki.find(".products li")
    |> Enum.map(fn pokemon ->
      link = Floki.find(pokemon, "a")

      %{
        id: Floki.attribute(link, "data-product_id") |> Floki.text() |> safe_to_integer(),
        sku: Floki.attribute(link, "data-product_sku") |> Floki.text(),
        name: Floki.find(pokemon, "h2") |> Floki.text(),
        price: Floki.find(pokemon, ".price") |> Floki.text(),
        image_url: pokemon |> Floki.find("img") |> Floki.attribute("src") |> Floki.text()
      }
    end)
  end

  defp safe_to_integer(""), do: nil
  defp safe_to_integer(value) when is_binary(value), do: String.to_integer(value)
end
