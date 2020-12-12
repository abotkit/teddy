defmodule Teddy.Spiders.Spider do
  alias Teddy.Spiders.Element

  def create_spider(module, website, elements) do
    quoted =
      quote do
        use Crawly.Spider

        @elements unquote(Macro.escape(elements))
        @filter unquote(website.filter)

        @impl Crawly.Spider
        def base_url(), do: unquote(website.base_url)

        @impl Crawly.Spider
        def init(), do: [start_urls: [base_url()]]

        @impl Crawly.Spider
        def parse_item(response) do
          {:ok, document} = Floki.parse_document(response.body)

          links =
            document
            |> Floki.find("a")
            |> Floki.attribute("href")
            |> Enum.map(&build_absolute_url/1)
            |> Enum.filter(&String.contains?(&1, @filter))
            |> Enum.map(&Crawly.Utils.request_from_url/1)

          item = %{"url" => response.request_url}

          item =
            Enum.reduce(
              @elements,
              item,
              fn element, map ->
                Map.put(map, element.name, Teddy.Spiders.Spider.extract(document, element))
              end
            )

          %Crawly.ParsedItem{items: [item], requests: links}
        end

        defp build_absolute_url(url), do: URI.merge(base_url(), url) |> to_string()
      end

    Module.create(module, quoted, Macro.Env.location(__ENV__))
    Crawly.Engine.start_spider(module)
  end

  def extract(document, %Element{multi: true} = element) do
    document
    |> Floki.find(element.css_selector)
    |> Enum.map(&Floki.text/1)
  end

  def extract(document, %Element{} = element) do
    document
    |> Floki.find(element.css_selector)
    |> Floki.text()
  end
end
