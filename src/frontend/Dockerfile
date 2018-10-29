FROM bitwalker/alpine-elixir-phoenix:latest

RUN mix archive.uninstall phx_new --force
RUN mix archive.install hex phx_new 1.4.0-rc.2 --force

COPY mix.exs mix.exs
RUN mix do deps.get, deps.compile

COPY assets/.babelrc assets/
COPY assets/package.json assets/
COPY assets/webpack.config.js assets/
RUN cd assets && \
    npm install

COPY assets/css assets/css/
COPY assets/js assets/js/
COPY assets/static assets/static/
# COPY assets/vendor assets/vendor/
COPY config config/
COPY lib lib/
COPY priv/gettext priv/gettext/
COPY test test/
RUN cd assets/ && \
    npm run deploy && \
    cd - && \
    mix do compile, phx.digest

CMD ["mix", "phx.server"]