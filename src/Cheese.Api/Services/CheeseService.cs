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
        throw new NotImplementedException();
    }

    public Cheese GetCheese(string id)
    {
        throw new NotImplementedException();
    }
}