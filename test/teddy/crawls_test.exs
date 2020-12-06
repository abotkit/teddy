defmodule Teddy.CrawlsTest do
  use Teddy.DataCase

  alias Teddy.Crawls

  describe "crawls" do
    alias Teddy.Crawls.Crawl

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def crawl_fixture(attrs \\ %{}) do
      {:ok, crawl} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Crawls.create_crawl()

      crawl
    end

    test "list_crawls/0 returns all crawls" do
      crawl = crawl_fixture()
      assert Crawls.list_crawls() == [crawl]
    end

    test "get_crawl!/1 returns the crawl with given id" do
      crawl = crawl_fixture()
      assert Crawls.get_crawl!(crawl.id) == crawl
    end

    test "create_crawl/1 with valid data creates a crawl" do
      assert {:ok, %Crawl{} = crawl} = Crawls.create_crawl(@valid_attrs)
    end

    test "create_crawl/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Crawls.create_crawl(@invalid_attrs)
    end

    test "update_crawl/2 with valid data updates the crawl" do
      crawl = crawl_fixture()
      assert {:ok, %Crawl{} = crawl} = Crawls.update_crawl(crawl, @update_attrs)
    end

    test "update_crawl/2 with invalid data returns error changeset" do
      crawl = crawl_fixture()
      assert {:error, %Ecto.Changeset{}} = Crawls.update_crawl(crawl, @invalid_attrs)
      assert crawl == Crawls.get_crawl!(crawl.id)
    end

    test "delete_crawl/1 deletes the crawl" do
      crawl = crawl_fixture()
      assert {:ok, %Crawl{}} = Crawls.delete_crawl(crawl)
      assert_raise Ecto.NoResultsError, fn -> Crawls.get_crawl!(crawl.id) end
    end

    test "change_crawl/1 returns a crawl changeset" do
      crawl = crawl_fixture()
      assert %Ecto.Changeset{} = Crawls.change_crawl(crawl)
    end
  end
end
