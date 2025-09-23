using HealthChecks.UI.Client;
using Microsoft.AspNetCore.Diagnostics.HealthChecks;
using Microsoft.AspNetCore.HttpOverrides;

var builder = WebApplication.CreateBuilder(args);
builder.Services.Configure<ForwardedHeadersOptions>(options =>
    options.ForwardedHeaders = ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto);
builder.Services.AddHealthChecks();
builder.Services.AddApplicationInsightsTelemetry();
builder.Logging.AddApplicationInsights();
builder.Host.UseDefaultServiceProvider(options =>
{
    options.ValidateScopes = true;
    options.ValidateOnBuild = true;
});
var app = builder.Build();
app.UseForwardedHeaders();
app.MapGet("/", () => $"Hello from {Environment.MachineName} at {DateTime.UtcNow}!");
app.MapGet("/status", () =>
    new
    {
        Status = $"Running at {DateTime.UtcNow}",
        Instance = Environment.MachineName
    });
app.MapGet("/pause/{pause}", async (int pause) =>
{
    var timeToWait = TimeSpan.FromSeconds(pause);
    await Task.Delay(timeToWait);
    var result = new
    {
        Status = $"Running at {DateTime.UtcNow}",
        Instance = Environment.MachineName
    };
    return result;
});
app.MapHealthChecks("/health", new HealthCheckOptions
{
    Predicate = _ => true,
    ResponseWriter = UIResponseWriter.WriteHealthCheckUIResponse
}).AllowAnonymous();
app.Run();