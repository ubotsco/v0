defmodule V0 do
  def log_level(%{request_path: "/up"}), do: false
  def log_level(_conn), do: :info
end
