using Microsoft.Azure.Cosmos;

public class DepartmentService : IDepartmentService
{
    private readonly CosmosClient _cosmosClient;

    public DepartmentService(CosmosClient cosmosClient)
    {
        _cosmosClient = cosmosClient;
    }
    
    public IEnumerable<Department> GetDepartments()
    {
        throw new NotImplementedException();
    }

    public Department GetDepartment(string id)
    {
        throw new NotImplementedException();
    }
}