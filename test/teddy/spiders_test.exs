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
end
