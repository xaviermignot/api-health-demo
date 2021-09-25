using Azure.Identity;
using Microsoft.Azure.Cosmos;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddTransient<ICheeseService, CheeseService>();
builder.Services.AddTransient<IDepartmentService, DepartmentService>();

var credential = new DefaultAzureCredential();
var cosmosClient = new CosmosClient(builder.Configuration["CosmosDb:AccountEndpoint"], credential);
builder.Services.AddSingleton<CosmosClient>(cosmosClient);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new() { Title = builder.Environment.ApplicationName, Version = "v1" });
});

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", $"{builder.Environment.ApplicationName} v1"));
}

app.MapGet("/api/cheeses", (ICheeseService svc) => Results.Ok(svc.GetCheeses()))
    .Produces<IEnumerable<Cheese>>(200);

app.MapGet(
    "/api/cheeses/{id}", 
    (string id, ICheeseService svc) => Results.Ok(svc.GetCheese(id)))
    .Produces<Cheese>(200);

app.MapGet("/api/departments", (IDepartmentService svc) => Results.Ok(svc.GetDepartments()))
    .Produces<IEnumerable<Department>>(200);

app.MapGet(
    "/api/departments/{id}", 
    (string id, IDepartmentService svc) => Results.Ok(svc.GetDepartment(id)))
    .Produces<Department>(200);
    
app.Run();

public record Department(string Name);
public record Cheese(string Name, string Milk, Department department);