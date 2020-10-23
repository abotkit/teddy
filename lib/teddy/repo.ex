defmodule Teddy.Repo do
  use Ecto.Repo,
    otp_app: :teddy,
    adapter: Ecto.Adapters.Postgres
end
