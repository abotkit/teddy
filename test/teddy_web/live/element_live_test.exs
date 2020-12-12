defmodule TeddyWeb.ElementLiveTest do
  use TeddyWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Teddy.Spiders

  @create_attrs %{css_selector: "some css_selector", multi: true, name: "some name", processing: [], website: 42}
  @update_attrs %{css_selector: "some updated css_selector", multi: false, name: "some updated name", processing: [], website: 43}
  @invalid_attrs %{css_selector: nil, multi: nil, name: nil, processing: nil, website: nil}

  defp fixture(:element) do
    {:ok, element} = Spiders.create_element(@create_attrs)
    element
  end

  defp create_element(_) do
    element = fixture(:element)
    %{element: element}
  end

  describe "Index" do
    setup [:create_element]

    test "lists all elements", %{conn: conn, element: element} do
      {:ok, _index_live, html} = live(conn, Routes.element_index_path(conn, :index))

      assert html =~ "Listing Elements"
      assert html =~ element.css_selector
    end

    test "saves new element", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.element_index_path(conn, :index))

      assert index_live |> element("a", "New Element") |> render_click() =~
               "New Element"

      assert_patch(index_live, Routes.element_index_path(conn, :new))

      assert index_live
             |> form("#element-form", element: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#element-form", element: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.element_index_path(conn, :index))

      assert html =~ "Element created successfully"
      assert html =~ "some css_selector"
    end

    test "updates element in listing", %{conn: conn, element: element} do
      {:ok, index_live, _html} = live(conn, Routes.element_index_path(conn, :index))

      assert index_live |> element("#element-#{element.id} a", "Edit") |> render_click() =~
               "Edit Element"

      assert_patch(index_live, Routes.element_index_path(conn, :edit, element))

      assert index_live
             |> form("#element-form", element: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#element-form", element: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.element_index_path(conn, :index))

      assert html =~ "Element updated successfully"
      assert html =~ "some updated css_selector"
    end

    test "deletes element in listing", %{conn: conn, element: element} do
      {:ok, index_live, _html} = live(conn, Routes.element_index_path(conn, :index))

      assert index_live |> element("#element-#{element.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#element-#{element.id}")
    end
  end

  describe "Show" do
    setup [:create_element]

    test "displays element", %{conn: conn, element: element} do
      {:ok, _show_live, html} = live(conn, Routes.element_show_path(conn, :show, element))

      assert html =~ "Show Element"
      assert html =~ element.css_selector
    end

    test "updates element within modal", %{conn: conn, element: element} do
      {:ok, show_live, _html} = live(conn, Routes.element_show_path(conn, :show, element))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Element"

      assert_patch(show_live, Routes.element_show_path(conn, :edit, element))

      assert show_live
             |> form("#element-form", element: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#element-form", element: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.element_show_path(conn, :show, element))

      assert html =~ "Element updated successfully"
      assert html =~ "some updated css_selector"
    end
  end
end
