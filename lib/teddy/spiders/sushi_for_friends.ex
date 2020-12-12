defmodule Teddy.Spiders.SushiForFriends do
  use Crawly.Spider

  @base_url "http://www.sushiandfriends-berlin.de/"

  @html_dishes ".section.speisekarte"
  @html_dish_details ".detail"
  @html_dish_price "span.price"

  @impl Crawly.Spider
  def base_url(), do: @base_url

  @impl Crawly.Spider
  def init() do
    [start_urls: [@base_url]]
  end

  @impl Crawly.Spider
  def parse_item(response) do
    {:ok, document} = Floki.parse_document(response.body)

    links =
      document
      |> Floki.find("a")
      |> Floki.attribute("href")
      |> Enum.uniq()
      |> Enum.map(&build_absolute_url/1)
      |> Enum.map(&Crawly.Utils.request_from_url/1)

    dishes = Floki.find(document, @html_dishes) |> Floki.find("li")

    items =
      for item <- dishes do
        %{
          url: response.request_url,
          name:
            item
            |> Floki.text(deep: false)
            |> clean_dish_name(),
          image:
            item
            |> Floki.find("img")
            |> Floki.attribute("src"),
          details:
            item
            |> Floki.find(@html_dish_details)
            |> Floki.text(deep: false),
          price:
            item
            |> Floki.find(@html_dish_price)
            |> Floki.text(deep: false)
        }
      end

    %Crawly.ParsedItem{items: items, requests: links}
  end

  defp build_absolute_url(url), do: URI.merge(base_url(), url) |> to_string()
  defp clean_dish_name(str), do: str |> String.trim() |> String.split("\.") |> List.last()
end
