# Coffee Shop Finder API

Welcome to the Coffee Shop Finder API! This is a simple Elixir and Phoenix-based application that allows users to find coffee shops near a given geographical location.

The entire application is containerized with Docker, providing a consistent and easy-to-manage development and production environment.

## Overview

The core functionality of this API is to:
- Accept a user's latitude and longitude.
- Return a list of nearby coffee shops, sorted by distance.
- Utilize an in-memory cache (`GenServer`) to store coffee shop data, reducing reliance on external data sources for frequent requests.

## Project Structure

The project follows a standard Phoenix application structure:

```
coffee_api/
├── lib/
│   ├── coffee_api/           # Core application logic (contexts, schemas)
│   └── coffee_api_web/       # Web interface (controllers, router, views)
├── config/                   # Application configuration for different environments
├── test/                     # Test files (unit, integration)
├── Dockerfile                # Defines the multi-stage Docker build for the application
└── docker-compose.yml        # Defines the services to run the application
```

## Getting Started

Follow these instructions to get the application running on your local machine.

### Prerequisites

You must have the following software installed:
- Docker
- Docker Compose

### Running the Application

1.  **Navigate to the project directory:**
    Open your terminal and change into the `coffee_api` directory.
    ```sh
    cd path/to/your/desktop/coffee_api
    ```

2.  **Build and run the container:**
    Use Docker Compose to build the image and start the application service.
    ```sh
    docker-compose up --build
    ```

3.  **Access the API:**
    Once the container is running, the API will be accessible at `http://localhost:4000`.

## Usage

### Finding Nearby Coffee Shops

To find coffee shops, make a `GET` request to the `/api/coffee_shops` endpoint with `lat` (latitude) and `lon` (longitude) as query parameters.

Here is an example using `curl`:

```sh
curl -X GET "http://localhost:4000/api/coffee_shops?lat=37.7749&lon=-122.4194"
```

This will return a JSON response containing a list of coffee shops sorted by their distance from the provided coordinates.

## Running Tests

The project includes a full test suite. To run the tests in a clean, containerized environment, execute the following command from the project's root directory:

```sh
docker-compose run --rm -e "MIX_ENV=test" app mix test
```

This command runs a one-off container using the `test` environment configuration, executes the test suite, and then removes the container.