using backend.IServices;
using backend.Models;
using backend.Services;
using Microsoft.EntityFrameworkCore;

AppContext.SetSwitch("Npgsql.EnableLegacyTimestampBehavior", true);

var builder = WebApplication.CreateBuilder(args);

var conn = builder.Configuration.GetConnectionString("PostgreSql");
builder.Services.AddDbContext<EvChargeDB>(options => options.UseNpgsql(conn));

builder.Services.AddControllers();
builder.Services.AddScoped<IUserService, UserService>();
builder.Services.AddScoped<IEventService, EventService>();
builder.Services.AddScoped<IChargerService, ChargerService>();
builder.Services.AddScoped<ICardService, CardService>();
builder.Services.AddScoped<IEmailService, EmailService>();

var app = builder.Build();

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
