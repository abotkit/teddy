defmodule TeddyWeb.ElementLive.FormComponent do
  use TeddyWeb, :live_component

  alias Teddy.Spiders

  @impl true
  def update(assigns, socket) do
    changeset = Spiders.change_element(assigns.element)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"element" => element_params}, socket) do
    changeset =
      socket.assigns.element
      |> Spiders.change_element(element_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"element" => element_params}, socket) do
    save_element(socket, socket.assigns.action, element_params)
  end

  defp save_element(socket, :edit, element_params) do
    case Spiders.update_element(socket.assigns.element, element_params) do
      {:ok, _element} ->
        {:noreply,
         socket
         |> put_flash(:info, "Element updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_element(socket, :new, element_params) do
    element_params = Map.put(element_params, "website_id", socket.assigns.website.id)

    case Spiders.create_element(element_params) do
      {:ok, _element} ->
        {:noreply,
         socket
         |> put_flash(:info, "Element created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
