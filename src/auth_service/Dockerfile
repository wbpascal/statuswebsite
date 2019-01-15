FROM bitwalker/alpine-elixir-phoenix:latest

# Install newest phoenix version
RUN mix archive.uninstall phx_new --force
RUN mix archive.install hex phx_new 1.4.0 --force

# Copy basic mix project to container
COPY mix.exs mix.exs

# Download and compile dependencies
RUN mix do deps.get, deps.compile
	
# Copy other static assets
COPY priv/gettext priv/gettext/
COPY priv/repo priv/repo/

# Copy source code to container
COPY config config/
COPY lib lib/
COPY test test/

# Compile source code
RUN mix compile

EXPOSE 80
CMD mix do ecto.create, ecto.migrate, phx.server
