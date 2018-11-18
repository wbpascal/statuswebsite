FROM bitwalker/alpine-elixir-phoenix:latest

# Install newest phoenix version
RUN mix archive.uninstall phx_new --force
RUN mix archive.install hex phx_new 1.4.0 --force

# Copy basic mix project to container
COPY mix.exs mix.exs

# Download and compile dependencies
RUN mix do deps.get, deps.compile

# Install webpack dependencies
COPY assets/.babelrc assets/
COPY assets/package.json assets/
COPY assets/webpack.config.js assets/
RUN cd assets && \
    npm install

# Copy other assets to container
COPY assets/css assets/css/
COPY assets/js assets/js/
COPY assets/static assets/static/
# COPY assets/vendor assets/vendor/

# Compile webpack assets
RUN cd assets/ && \
    npm run deploy
	
# Copy other static assets
COPY priv/gettext priv/gettext/
	
# Digest and compress static files (Disabled atm)
# RUN mix phx.digest

# Copy source code to container
COPY config config/
COPY lib lib/
COPY test test/

# Compile source code
RUN mix compile

EXPOSE 80
CMD ["mix", "phx.server"]