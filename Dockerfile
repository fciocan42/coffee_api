# Etapa 1: Build - Aici compilăm aplicația
FROM hexpm/elixir:1.15.7-erlang-26.2.1-alpine-3.18.4 AS build

# Argument pentru a controla mediul. Default este 'prod'.
ARG MIX_ENV="prod"
ENV MIX_ENV=${MIX_ENV}

# Instalează uneltele necesare pentru build
RUN apk add --no-cache build-base git

WORKDIR /app

# Instalează Hex și Rebar
RUN mix local.hex --force && mix local.rebar --force

# Copiază fișierele de dependențe și le instalează
# Acest pas este separat pentru a beneficia de caching-ul Docker
COPY mix.exs mix.lock ./
RUN if [ "${MIX_ENV}" = "test" ]; then mix deps.get; else mix deps.get --only prod; fi
RUN mix deps.compile

# Copiază restul aplicației
COPY . .

# Compilează aplicația și generează o versiune de release
RUN mix release

# Etapa 2: Release - Aici creăm imaginea finală, mult mai mică
FROM alpine:3.18.4 AS app

WORKDIR /app

# Setează variabilele de mediu necesare pentru a rula aplicația Phoenix
ENV HOME=/app
ENV MIX_ENV=prod

# Copiază release-ul compilat din etapa de build
COPY --from=build /app/_build/prod/rel/coffee_api .

# Expune portul pe care va rula serverul Phoenix
EXPOSE 4000

# Comanda pentru a porni serverul
CMD ["bin/coffee_api", "start"]