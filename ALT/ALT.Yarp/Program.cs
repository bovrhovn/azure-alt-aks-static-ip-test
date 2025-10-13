using System.Collections;
using HealthChecks.UI.Client;
using Microsoft.ApplicationInsights;
using Microsoft.AspNetCore.Diagnostics.HealthChecks;
using Microsoft.AspNetCore.HttpOverrides;
using Yarp.ReverseProxy.Transforms;

var builder = WebApplication.CreateBuilder(args);
// builder.Services.Configure<ForwardedHeadersOptions>(options =>
//     options.ForwardedHeaders = ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto);
builder.Services.AddHealthChecks();
builder.Services.AddApplicationInsightsTelemetry();
builder.Logging.AddApplicationInsights();
builder.Services.AddReverseProxy()
    .LoadFromConfig(builder.Configuration.GetSection("ReverseProxy"))
    .AddTransforms(builderContext =>
    {
        builderContext.AddRequestTransform(transformContext =>
        {
            var telemetryClient = transformContext.HttpContext.RequestServices.GetRequiredService<TelemetryClient>();
            telemetryClient.TrackTrace(
                $"Proxying request to {transformContext.DestinationPrefix}{transformContext.Path}");
            telemetryClient.TrackEvent("YARP Proxy Request", new Dictionary<string, string>
            {
                { "Path", transformContext.Path },
                { "Destination", transformContext.DestinationPrefix }
            });
            return ValueTask.CompletedTask;
        });
    });

builder.Host.UseDefaultServiceProvider(options =>
{
    options.ValidateScopes = true;
    options.ValidateOnBuild = true;
});
var app = builder.Build();
//app.UseForwardedHeaders();
app.UseRouting();
app.MapReverseProxy();
app.MapHealthChecks("/health", new HealthCheckOptions
{
    Predicate = _ => true,
    ResponseWriter = UIResponseWriter.WriteHealthCheckUIResponse
}).AllowAnonymous();
app.MapGet("/envs", () =>
    $"Environment Variables:\n{string.Join("\n", Environment.GetEnvironmentVariables().Cast<DictionaryEntry>().Select(kv => $"{kv.Key}={kv.Value}"))}");
app.Run();