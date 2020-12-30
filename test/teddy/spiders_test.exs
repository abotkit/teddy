defmodule Teddy.SpidersTest do
  use Teddy.DataCase

  alias Teddy.Spiders

  describe "websites" do
    alias Teddy.Spiders.Website

    @valid_attrs %{base_url: "some base_url", description: "some description", name: "some name"}
    @update_attrs %{base_url: "some updated base_url", description: "some updated description", name: "some updated name"}
    @invalid_attrs %{base_url: nil, description: nil, name: nil}

    def website_fixture(attrs \\ %{}) do
      {:ok, website} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Spiders.create_website()

      website
    end

    test "list_websites/0 returns all websites" do
      website = website_fixture()
      assert Spiders.list_websites() == [website]
    end

    test "get_website!/1 returns the website with given id" do
      website = website_fixture()
      assert Spiders.get_website!(website.id) == website
    end

    test "create_website/1 with valid data creates a website" do
      assert {:ok, %Website{} = website} = Spiders.create_website(@valid_attrs)
      assert website.base_url == "some base_url"
      assert website.description == "some description"
      assert website.name == "some name"
    end

    test "create_website/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Spiders.create_website(@invalid_attrs)
    end

    test "update_website/2 with valid data updates the website" do
      website = website_fixture()
      assert {:ok, %Website{} = website} = Spiders.update_website(website, @update_attrs)
      assert website.base_url == "some updated base_url"
      assert website.description == "some updated description"
      assert website.name == "some updated name"
    end

    test "update_website/2 with invalid data returns error changeset" do
      website = website_fixture()
      assert {:error, %Ecto.Changeset{}} = Spiders.update_website(website, @invalid_attrs)
      assert website == Spiders.get_website!(website.id)
    end

    test "delete_website/1 deletes the website" do
      website = website_fixture()
      assert {:ok, %Website{}} = Spiders.delete_website(website)
      assert_raise Ecto.NoResultsError, fn -> Spiders.get_website!(website.id) end
    end

    test "change_website/1 returns a website changeset" do
      website = website_fixture()
      assert %Ecto.Changeset{} = Spiders.change_website(website)
    end
  end

  describe "elements" do
    alias Teddy.Spiders.Element

    @valid_attrs %{css_selector: "some css_selector", multi: true, name: "some name", processing: [], website: 42}
    @update_attrs %{css_selector: "some updated css_selector", multi: false, name: "some updated name", processing: [], website: 43}
    @invalid_attrs %{css_selector: nil, multi: nil, name: nil, processing: nil, website: nil}

    def element_fixture(attrs \\ %{}) do
      {:ok, element} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Spiders.create_element()

      element
    end

    test "list_elements/0 returns all elements" do
      element = element_fixture()
      assert Spiders.list_elements() == [element]
    end

    test "get_element!/1 returns the element with given id" do
      element = element_fixture()
      assert Spiders.get_element!(element.id) == element
    end

    test "create_element/1 with valid data creates a element" do
      assert {:ok, %Element{} = element} = Spiders.create_element(@valid_attrs)
      assert element.css_selector == "some css_selector"
      assert element.multi == true
      assert element.name == "some name"
      assert element.processing == []
      assert element.website == 42
    end

    test "create_element/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Spiders.create_element(@invalid_attrs)
    end

    test "update_element/2 with valid data updates the element" do
      element = element_fixture()
      assert {:ok, %Element{} = element} = Spiders.update_element(element, @update_attrs)
      assert element.css_selector == "some updated css_selector"
      assert element.multi == false
      assert element.name == "some updated name"
      assert element.processing == []
      assert element.website == 43
    end

    test "update_element/2 with invalid data returns error changeset" do
      element = element_fixture()
      assert {:error, %Ecto.Changeset{}} = Spiders.update_element(element, @invalid_attrs)
      assert element == Spiders.get_element!(element.id)
    end

    test "delete_element/1 deletes the element" do
      element = element_fixture()
      assert {:ok, %Element{}} = Spiders.delete_element(element)
      assert_raise Ecto.NoResultsError, fn -> Spiders.get_element!(element.id) end
    end

    test "change_element/1 returns a element changeset" do
      element = element_fixture()
      assert %Ecto.Changeset{} = Spiders.change_element(element)
    end
  end

  describe "buckets" do
    alias Teddy.Spiders.Bucket

    @valid_attrs %{access_key_id: "some access_key_id", name: "some name", region: "some region", secret_access_key: "some secret_access_key"}
    @update_attrs %{access_key_id: "some updated access_key_id", name: "some updated name", region: "some updated region", secret_access_key: "some updated secret_access_key"}
    @invalid_attrs %{access_key_id: nil, name: nil, region: nil, secret_access_key: nil}

    def bucket_fixture(attrs \\ %{}) do
      {:ok, bucket} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Spiders.create_bucket()

      bucket
    end

    test "list_buckets/0 returns all buckets" do
      bucket = bucket_fixture()
      assert Spiders.list_buckets() == [bucket]
    end

    test "get_bucket!/1 returns the bucket with given id" do
      bucket = bucket_fixture()
      assert Spiders.get_bucket!(bucket.id) == bucket
    end

    test "create_bucket/1 with valid data creates a bucket" do
      assert {:ok, %Bucket{} = bucket} = Spiders.create_bucket(@valid_attrs)
      assert bucket.access_key_id == "some access_key_id"
      assert bucket.name == "some name"
      assert bucket.region == "some region"
      assert bucket.secret_access_key == "some secret_access_key"
    end

    test "create_bucket/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Spiders.create_bucket(@invalid_attrs)
    end

    test "update_bucket/2 with valid data updates the bucket" do
      bucket = bucket_fixture()
      assert {:ok, %Bucket{} = bucket} = Spiders.update_bucket(bucket, @update_attrs)
      assert bucket.access_key_id == "some updated access_key_id"
      assert bucket.name == "some updated name"
      assert bucket.region == "some updated region"
      assert bucket.secret_access_key == "some updated secret_access_key"
    end

    test "update_bucket/2 with invalid data returns error changeset" do
      bucket = bucket_fixture()
      assert {:error, %Ecto.Changeset{}} = Spiders.update_bucket(bucket, @invalid_attrs)
      assert bucket == Spiders.get_bucket!(bucket.id)
    end

    test "delete_bucket/1 deletes the bucket" do
      bucket = bucket_fixture()
      assert {:ok, %Bucket{}} = Spiders.delete_bucket(bucket)
      assert_raise Ecto.NoResultsError, fn -> Spiders.get_bucket!(bucket.id) end
    end

    test "change_bucket/1 returns a bucket changeset" do
      bucket = bucket_fixture()
      assert %Ecto.Changeset{} = Spiders.change_bucket(bucket)
    end
  end
end
