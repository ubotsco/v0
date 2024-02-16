defmodule V0.Health do
  @moduledoc """
  Basic health check endpoint.

  Add this to Router:

      scope "/", log: false do
        forward "/up", V0.Health
      end

  Disable log for /up path in Endpoint:

      plug Plug.Telemetry,
        event_prefix: [:phoenix, :endpoint],
        log: {V0, :log_level, []}

  """
  @behaviour Plug

  @green "#2ECC40"

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, _params) do
    Phoenix.Controller.html(conn, render(@green))
  end

  def render(color) do
    """
    <html>
      <body style="background-color: #{color}"></body>
    </html>
    """
  end
end
