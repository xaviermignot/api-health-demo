using System.Linq;
using Microsoft.Azure.Cosmos;
using Moq;
using Xunit;

public class CheeseServiceTests
{
    private readonly Mock<CosmosClient> _fakeCosmosClient = new Mock<CosmosClient>();

    private readonly CheeseService _cheeseService;

    public CheeseServiceTests()
    {
        _cheeseService = new CheeseService(_fakeCosmosClient.Object);
        MockCheeseContainer();
    }

    [Fact]
    public void GetCheesesShouldReturnAllCheeses()
    {
        // Act
        var result = _cheeseService.GetCheeses();

        // Assert
        _fakeCosmosClient.Verify(c => c.GetContainer("db-api-health-demo", "cheeses"), Times.Once);
        Assert.Equal(2, result.Count());

        foreach (var cheese in result)
        {
            Assert.NotNull(cheese);
            Assert.False(string.IsNullOrEmpty(cheese.Name));
            Assert.False(string.IsNullOrEmpty(cheese.Milk));
            Assert.NotNull(cheese.department);
        }
    }

    private void MockCheeseContainer()
    {
        var fakeCheeseContainer = new Mock<Container>();

        var cheeses = new[]
        {
            new Cheese("Comté", "vache", new Department("Ain")),
            new Cheese("Cabécou", "chèvre", new Department("Aveyron"))
        }.AsQueryable().OrderBy(c => c.Name);

        fakeCheeseContainer.Setup(
            cc => cc.GetItemLinqQueryable<Cheese>(
                It.IsAny<bool>(), It.IsAny<string>(), It.IsAny<QueryRequestOptions>(),
                It.IsAny<CosmosLinqSerializerOptions>())
            ).Returns(cheeses);

        _fakeCosmosClient.Setup(c => c.GetContainer("db-api-health-demo", "cheeses")).Returns(fakeCheeseContainer.Object);
    }
}