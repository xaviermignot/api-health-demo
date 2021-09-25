public interface ICheeseService
{
    IEnumerable<Cheese> GetCheeses();

    Cheese GetCheese(string id);
}