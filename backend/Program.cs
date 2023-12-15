using backend.Controllers;
using backend.Models;
using backend.Services;
using Microsoft.EntityFrameworkCore;

AppContext.SetSwitch("Npgsql.EnableLegacyTimestampBehavior", true);


var builder = WebApplication.CreateBuilder(args);

var conn = builder.Configuration.GetConnectionString("PostgreSql");
builder.Services.AddDbContext<EvChargeDB>(options => options.UseNpgsql(conn));


builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddScoped<UserService>();
builder.Services.AddScoped<EventService>();
builder.Services.AddScoped<ChargerService>();
builder.Services.AddSwaggerGen();


var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

//app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
