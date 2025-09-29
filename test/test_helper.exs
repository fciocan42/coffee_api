ExUnit.start()

Mox.defmock(CoffeeApi.FinchMock, for: Finch)
Mox.defmock(CoffeeApi.DataSourceMock, for: CoffeeApi.DataSource)
Mox.defmock(CoffeeApi.DataCache, for: CoffeeApi.DataCache)
