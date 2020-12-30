defmodule TeddyWeb.BucketLive.FormComponent do
  use TeddyWeb, :live_component

  alias Teddy.Spiders

  @impl true
  def update(%{bucket: bucket} = assigns, socket) do
    changeset = Spiders.change_bucket(bucket)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"bucket" => bucket_params}, socket) do
    changeset =
      socket.assigns.bucket
      |> Spiders.change_bucket(bucket_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"bucket" => bucket_params}, socket) do
    save_bucket(socket, socket.assigns.action, bucket_params)
  end

  defp save_bucket(socket, :edit, bucket_params) do
    case Spiders.update_bucket(socket.assigns.bucket, bucket_params) do
      {:ok, _bucket} ->
        {:noreply,
         socket
         |> put_flash(:info, "Bucket updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_bucket(socket, :new, bucket_params) do
    case Spiders.create_bucket(bucket_params) do
      {:ok, _bucket} ->
        {:noreply,
         socket
         |> put_flash(:info, "Bucket created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
