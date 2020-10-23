defmodule TeddyWeb.CrawlLiveTest do
  use TeddyWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Teddy.Crawls

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp fixture(:crawl) do
    {:ok, crawl} = Crawls.create_crawl(@create_attrs)
    crawl
  end

  defp create_crawl(_) do
    crawl = fixture(:crawl)
    %{crawl: crawl}
  end

  describe "Index" do
    setup [:create_crawl]

    test "lists all crawls", %{conn: conn, crawl: crawl} do
      {:ok, _index_live, html} = live(conn, Routes.crawl_index_path(conn, :index))

      assert html =~ "Listing Crawls"
    end

    test "saves new crawl", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.crawl_index_path(conn, :index))

      assert index_live |> element("a", "New Crawl") |> render_click() =~
               "New Crawl"

      assert_patch(index_live, Routes.crawl_index_path(conn, :new))

      assert index_live
             |> form("#crawl-form", crawl: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#crawl-form", crawl: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.crawl_index_path(conn, :index))

      assert html =~ "Crawl created successfully"
    end

    test "updates crawl in listing", %{conn: conn, crawl: crawl} do
      {:ok, index_live, _html} = live(conn, Routes.crawl_index_path(conn, :index))

      assert index_live |> element("#crawl-#{crawl.id} a", "Edit") |> render_click() =~
               "Edit Crawl"

      assert_patch(index_live, Routes.crawl_index_path(conn, :edit, crawl))

      assert index_live
             |> form("#crawl-form", crawl: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#crawl-form", crawl: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.crawl_index_path(conn, :index))

      assert html =~ "Crawl updated successfully"
    end

    test "deletes crawl in listing", %{conn: conn, crawl: crawl} do
      {:ok, index_live, _html} = live(conn, Routes.crawl_index_path(conn, :index))

      assert index_live |> element("#crawl-#{crawl.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#crawl-#{crawl.id}")
    end
  end

  describe "Show" do
    setup [:create_crawl]

    test "displays crawl", %{conn: conn, crawl: crawl} do
      {:ok, _show_live, html} = live(conn, Routes.crawl_show_path(conn, :show, crawl))

      assert html =~ "Show Crawl"
    end

    test "updates crawl within modal", %{conn: conn, crawl: crawl} do
      {:ok, show_live, _html} = live(conn, Routes.crawl_show_path(conn, :show, crawl))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Crawl"

      assert_patch(show_live, Routes.crawl_show_path(conn, :edit, crawl))

      assert show_live
             |> form("#crawl-form", crawl: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#crawl-form", crawl: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.crawl_show_path(conn, :show, crawl))

      assert html =~ "Crawl updated successfully"
    end
  end
end
