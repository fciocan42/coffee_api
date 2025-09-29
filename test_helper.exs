ExUnit.start()

# Create a mock for Finch http client
Mox.defmock(CoffeeApi.FinchMock, for: Finch)
Mox.defmock(CoffeeApi.DataSourceMock, for: CoffeeApi.DataSource)
