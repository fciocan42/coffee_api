# Coffee Shop Finder API

Welcome to the Coffee Shop Finder API! This is a simple Elixir and Phoenix-based application that allows users to find coffee shops near a given geographical location.

The entire application is containerized with Docker, providing a consistent and easy-to-manage development and production environment.

## Overview

You have been hired by a company that builds an app for coffee addicts. You are responsible for writing a REST API that offers the possibility to take the user's coordinates and return a list of the three closest coffee shops (including distance from the user) in order from the closest to farthest.

### Data Source

The coffee shops are stored in a remote CSV file with the following columns: `Name`, `X`, `Y`.

-   **URL:** `https://static.reasig.ro/interview/coffee_shops_exerceise/coffee_shops.csv`
-   **Data Quality:** The quality of data in this list may vary. Malformed entries should be handled appropriately.

### API Response

The API should return a list of the three closest coffee shops (including name, location, and distance from the user), sorted from closest to farthest.

-   Distances should be rounded to four decimal places.
-   It is assumed that all coordinates lie on a plane for distance calculation.

#### Example

For the provided coordinates `X=47.6` and `Y=-122.4`, the response should contain these coffee shops:
-   Starbucks Seattle2
-   Starbucks Seattle
-   Starbucks SF

## Project Structure

The project follows a standard Phoenix application structure:

```
coffee_api/
├── lib/
│   ├── coffee_api/           # Core application logic (contexts, schemas)
│   └── coffee_api_web/       # Web interface (controllers, router, views)
├── config/                   # Application configuration for different environments
├── test/                     # Test files (unit, integration)
├── Dockerfile                # Defines the Docker build for the application
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