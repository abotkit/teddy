defmodule Teddy.Spiders do
  @spider_module_prefix "Elixir.Teddy.Spiders."

  alias Teddy.Repo
  alias Teddy.Spiders.Element
  alias Teddy.Spiders.Website

  import Ecto.Query, only: [from: 2]

  def list_spiders() do
    running_spiders = running_spider_pids() |> Enum.map(&format_running_spider/1)

    for website <- list_websites() do
      running_proc = Enum.find(running_spiders, fn running -> running.name == website.name end)

      Map.merge(
        %{
          name: website.name,
          id: website.id,
          status: "stopped",
          proc_info: nil,
          stats: nil
        },
        running_proc || %{}
      )
    end
  end

  defp format_running_spider(pid) do
    process_info = Process.info(pid)

    %{
      name: module_to_name(process_info[:registered_name]),
      status: "started",
      proc_info: process_info,
      stats: spider_stats(process_info[:registered_name])
    }
  end

  defp running_spider_pids() do
    Supervisor.which_children(Crawly.EngineSup)
    |> get_in([Access.all(), Access.elem(1)])
    |> Enum.map(&Process.info/1)
    |> Enum.map(&get_in(&1, [:links, Access.at(0)]))
  end

  defp module_to_name(module),
    do: Atom.to_string(module) |> String.replace_prefix(@spider_module_prefix, "")

  def start_spider(website_id) do
    website = get_website!(website_id)

    module =
      (@spider_module_prefix <> website.name)
      |> String.to_atom()

    Teddy.Spiders.Spider.create_spider(module, website, website.elements)
  end

  def stop_spider(website_id) do
    website = get_website!(website_id)

    module =
      (@spider_module_prefix <> website.name)
      |> String.to_atom()

    Crawly.Engine.stop_spider(module)
  end

  @doc """
  Returns `data_storage` and `requests_storage` statistics about the running
  crawl or an error if the spider is stopped.

  ## For running spiders

      iex> spider_stats(running_spider)
      %{data_storage: {:stored_items, 0}, requests_storage: {:stored_requests, 23}}

  ## For stopped spiders

      iex> spider_stats(stopped_spider)
      %{
          data_storage: {:error, :data_storage_worker_not_running},
          requests_storage: {:error, :storage_worker_not_running}
      }

  """
  def spider_stats(module) do
    %{
      data_storage: Crawly.DataStorage.stats(module),
      requests_storage: Crawly.RequestsStorage.stats(module)
    }
  end

  @doc "Checks if a spider has no websites left in the queue"
  def done?(module) do
    case {
      Crawly.DataStorage.stats(module),
      Crawly.RequestsStorage.stats(module)
    } do
      # Nothing stored
      {{:stored_items, 0}, _} -> false
      # Queue empty, something stored
      {_, {:stored_requests, 0}} -> true
      # Queue not empty, something stored
      {_, {:stored_requests, _}} -> false
      # Spider not running
      _ -> true
    end
  end

  def list_websites do
    Repo.all(Website)
  end

  def list_elements(website_id) do
    from(e in Element,
      where:
        e.website_id ==
          ^website_id
    )
    |> Repo.all()
  end

  def get_website!(id) do
    Repo.get!(Website, id)
    |> Repo.preload([:elements])
  end

  def create_website(attrs \\ %{}) do
    %Website{}
    |> Website.changeset(attrs)
    |> Repo.insert()
  end

  def update_website(%Website{} = website, attrs) do
    website
    |> Website.changeset(attrs)
    |> Repo.update()
  end

  def delete_website(%Website{} = website) do
    Repo.delete(website)
  end

  def change_website(%Website{} = website, attrs \\ %{}) do
    Website.changeset(website, attrs)
  end

  def list_elements do
    Repo.all(Element)
  end

  def get_element!(id), do: Repo.get!(Element, id)

  def create_element(attrs \\ %{}) do
    %Element{}
    |> Element.changeset(attrs)
    |> Repo.insert()
  end

  def update_element(%Element{} = element, attrs) do
    element
    |> Element.changeset(attrs)
    |> Repo.update()
  end

  def delete_element(%Element{} = element) do
    Repo.delete(element)
  end

  def change_element(%Element{} = element, attrs \\ %{}) do
    Element.changeset(element, attrs)
  end

  alias Teddy.Spiders.Bucket

  @doc """
  Returns the list of buckets.

  ## Examples

      iex> list_buckets()
      [%Bucket{}, ...]

  """
  def list_buckets do
    Repo.all(Bucket)
  end

  @doc """
  Gets a single bucket.

  Raises `Ecto.NoResultsError` if the Bucket does not exist.

  ## Examples

      iex> get_bucket!(123)
      %Bucket{}

      iex> get_bucket!(456)
      ** (Ecto.NoResultsError)

  """
  def get_bucket!(id), do: Repo.get!(Bucket, id)

  @doc """
  Creates a bucket.

  ## Examples

      iex> create_bucket(%{field: value})
      {:ok, %Bucket{}}

      iex> create_bucket(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_bucket(attrs \\ %{}) do
    %Bucket{}
    |> Bucket.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a bucket.

  ## Examples

      iex> update_bucket(bucket, %{field: new_value})
      {:ok, %Bucket{}}

      iex> update_bucket(bucket, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_bucket(%Bucket{} = bucket, attrs) do
    bucket
    |> Bucket.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a bucket.

  ## Examples

      iex> delete_bucket(bucket)
      {:ok, %Bucket{}}

      iex> delete_bucket(bucket)
      {:error, %Ecto.Changeset{}}

  """
  def delete_bucket(%Bucket{} = bucket) do
    Repo.delete(bucket)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bucket changes.

  ## Examples

      iex> change_bucket(bucket)
      %Ecto.Changeset{data: %Bucket{}}

  """
  def change_bucket(%Bucket{} = bucket, attrs \\ %{}) do
    Bucket.changeset(bucket, attrs)
  end
end
