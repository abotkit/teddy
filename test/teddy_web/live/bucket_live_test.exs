defmodule TeddyWeb.BucketLiveTest do
  use TeddyWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Teddy.Spiders

  @create_attrs %{access_key_id: "some access_key_id", name: "some name", region: "some region", secret_access_key: "some secret_access_key"}
  @update_attrs %{access_key_id: "some updated access_key_id", name: "some updated name", region: "some updated region", secret_access_key: "some updated secret_access_key"}
  @invalid_attrs %{access_key_id: nil, name: nil, region: nil, secret_access_key: nil}

  defp fixture(:bucket) do
    {:ok, bucket} = Spiders.create_bucket(@create_attrs)
    bucket
  end

  defp create_bucket(_) do
    bucket = fixture(:bucket)
    %{bucket: bucket}
  end

  describe "Index" do
    setup [:create_bucket]

    test "lists all buckets", %{conn: conn, bucket: bucket} do
      {:ok, _index_live, html} = live(conn, Routes.bucket_index_path(conn, :index))

      assert html =~ "Listing Buckets"
      assert html =~ bucket.access_key_id
    end

    test "saves new bucket", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.bucket_index_path(conn, :index))

      assert index_live |> element("a", "New Bucket") |> render_click() =~
               "New Bucket"

      assert_patch(index_live, Routes.bucket_index_path(conn, :new))

      assert index_live
             |> form("#bucket-form", bucket: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#bucket-form", bucket: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.bucket_index_path(conn, :index))

      assert html =~ "Bucket created successfully"
      assert html =~ "some access_key_id"
    end

    test "updates bucket in listing", %{conn: conn, bucket: bucket} do
      {:ok, index_live, _html} = live(conn, Routes.bucket_index_path(conn, :index))

      assert index_live |> element("#bucket-#{bucket.id} a", "Edit") |> render_click() =~
               "Edit Bucket"

      assert_patch(index_live, Routes.bucket_index_path(conn, :edit, bucket))

      assert index_live
             |> form("#bucket-form", bucket: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#bucket-form", bucket: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.bucket_index_path(conn, :index))

      assert html =~ "Bucket updated successfully"
      assert html =~ "some updated access_key_id"
    end

    test "deletes bucket in listing", %{conn: conn, bucket: bucket} do
      {:ok, index_live, _html} = live(conn, Routes.bucket_index_path(conn, :index))

      assert index_live |> element("#bucket-#{bucket.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#bucket-#{bucket.id}")
    end
  end

  describe "Show" do
    setup [:create_bucket]

    test "displays bucket", %{conn: conn, bucket: bucket} do
      {:ok, _show_live, html} = live(conn, Routes.bucket_show_path(conn, :show, bucket))

      assert html =~ "Show Bucket"
      assert html =~ bucket.access_key_id
    end

    test "updates bucket within modal", %{conn: conn, bucket: bucket} do
      {:ok, show_live, _html} = live(conn, Routes.bucket_show_path(conn, :show, bucket))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Bucket"

      assert_patch(show_live, Routes.bucket_show_path(conn, :edit, bucket))

      assert show_live
             |> form("#bucket-form", bucket: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#bucket-form", bucket: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.bucket_show_path(conn, :show, bucket))

      assert html =~ "Bucket updated successfully"
      assert html =~ "some updated access_key_id"
    end
  end
end
