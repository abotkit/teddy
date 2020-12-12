defmodule Teddy.Spiders.PileaPerge do
  use Crawly.Spider

  @base_url "https://www.pileaperge.com"
  @product_page_prefix "/products/"

  @html_product_title ".product-page--title"
  @html_price "span.actual-price"
  @html_description "[itemprop='description'] p span"
  @html_properties "[itemprop='description'] p"

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
      |> Enum.filter(&String.contains?(&1, @product_page_prefix))
      |> Enum.map(&Crawly.Utils.request_from_url/1)

    item = %{
      url: response.request_url,
      name:
        document
        |> Floki.find(@html_product_title)
        |> Floki.text()
        |> split_title(),
      price:
        document
        |> Floki.find(@html_price)
        |> Floki.text(),
      description:
        document
        |> Floki.find(@html_description)
        |> Floki.text()
        |> String.replace(" ", " ")
        |> String.trim(),
      properties:
        document
        |> Floki.find(@html_properties)
        |> Enum.drop(1)
        |> Enum.map(&Floki.text/1)
        |> Enum.map(&String.replace(&1, " ", " "))
        |> Enum.reject(fn str -> String.trim(str) == "" end)
    }

    %Crawly.ParsedItem{items: [item], requests: links}
  end

  defp build_absolute_url(url), do: URI.merge(base_url(), url) |> to_string()
  defp split_title(product_title), do: String.split(product_title, " | ") |> List.first()
end
