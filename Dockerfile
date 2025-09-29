# Stage 1: Build - This is where we compile the application
FROM hexpm/elixir:1.15.7-erlang-26.2.1-alpine-3.18.4 AS build

# Argument to control the environment. Defaults to 'prod'.
ARG MIX_ENV="prod"
ENV MIX_ENV=${MIX_ENV}

# Install build tools
RUN apk add --no-cache build-base git

WORKDIR /app

# Install Hex and Rebar
RUN mix local.hex --force && mix local.rebar --force

# Copy dependency files and install them
# This is a separate step to benefit from Docker's layer caching
COPY mix.exs mix.lock ./
RUN if [ "${MIX_ENV}" = "test" ]; then mix deps.get; else mix deps.get --only prod; fi
RUN mix deps.compile

# Copy the rest of the application source code
COPY . .

# Compile the application and generate a release
RUN mix release

# Stage 2: Release - Here we build the final, much smaller image
FROM alpine:3.18.4 AS app

# Install runtime dependencies required by Erlang/Elixir
RUN apk add --no-cache ncurses-libs libstdc++

WORKDIR /app

# Set environment variables needed to run the Phoenix application
ENV HOME=/app
ENV MIX_ENV=prod

# Copy the compiled release from the build stage
COPY --from=build /app/_build/prod/rel/coffee_api .

# Expose the port the Phoenix server will run on
EXPOSE 4000

# The command to start the server
CMD ["bin/coffee_api", "start"]