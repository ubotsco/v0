defmodule Mix.Tasks.V0 do
  @shortdoc "Generates base files"

  use Mix.Task

  @paths [".", :v0]

  @versions [
    erlang: "26.2.2",
    elixir: "1.16.1",
    nodejs: "20.8.0",
    alpine: "3.19.1"
  ]

  @doc false
  def run(_args) do
    versions = Application.get_env(:v0, :versions, [])
    versions = Keyword.merge(@versions, versions)

    otp_app = Mix.Phoenix.otp_app()
    app_namespace = Mix.Phoenix.base()
    web_namespace = app_namespace |> Mix.Phoenix.web_module() |> inspect()

    binding = [
      otp_app: otp_app,
      app_namespace: app_namespace,
      web_namespace: web_namespace,
      versions: Map.new(versions)
    ]

    Mix.Phoenix.copy_from(@paths, "priv/templates", binding, [
      {:eex, ".tool-versions.eex", ".tool-versions"},

      # Config
      {:eex, "config/prod.exs.eex", "config/prod.exs"},
      {:eex, "config/runtime.exs.eex", "config/runtime.exs"},

      # Docker
      {:eex, "rel/env.sh.eex.eex", "rel/env.sh.eex"},
      {:eex, "rel/overlays/bin/server.sh.eex", "rel/overlays/bin/server"},
      {:eex, "Dockerfile.eex", "Dockerfile"},
      {:eex, ".dockerignore.eex", ".dockerignore"},

      # Github Actions
      {:eex, ".github/actions/setup-elixir/action.yaml.eex",
       ".github/actions/setup-elixir/action.yaml"},
      {:eex, ".github/workflows/main.yaml.eex", ".github/workflows/main.yaml"},

      # Utilities
      {:eex, ".iex.exs.eex", ".iex.exs"},
      {:eex, "Makefile.eex", "Makefile"}
    ])

    File.chmod!("rel/overlays/bin/server", 0o755)

    Mix.shell().info("""

    # Configure Oban auth key
    echo "OBAN_AUTH_KEY=your-secret-key" >> .env

    # Run setup
    make setup
    """)
  end
end
