using Microsoft.Azure.Cosmos;

public class CheeseService : ICheeseService
{
    private readonly CosmosClient _cosmosClient;

    public CheeseService(CosmosClient cosmosClient)
    {
        _cosmosClient = cosmosClient;
    }

    public IEnumerable<Cheese> GetCheeses()
    {
        var cheeseContainer = _cosmosClient.GetContainer("db-api-health-demo", "cheeses");

        return cheeseContainer.GetItemLinqQueryable<Cheese>(true);
    }

    public Cheese GetCheese(string id)
    {
        throw new NotImplementedException();
    }
}