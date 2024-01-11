using backend.IServices;
using backend.Models;
using backend.Services;
using Microsoft.EntityFrameworkCore;

public class Startup
{
    public Startup(IConfiguration configuration)
    {
        Configuration = configuration;
    }

    public IConfiguration Configuration { get; }

    public void ConfigureServices(IServiceCollection services)
    {
        AppContext.SetSwitch("Npgsql.EnableLegacyTimestampBehavior", true);

        var conn = Configuration.GetConnectionString("PostgreSql");
        services.AddDbContext<EvChargeDB>(options => options.UseNpgsql(conn));

        services.AddCors(options =>
        {
            options.AddPolicy("AllowLocalhost3000",
                builder =>
                {
                    builder.WithOrigins("http://localhost:3000")
                           .AllowAnyHeader()
                           .AllowAnyMethod();
                });
        });

        services.AddControllers();
        services.AddScoped<IUserService, UserService>();
        services.AddScoped<IEventService, EventService>();
        services.AddScoped<IChargerService, ChargerService>();
        services.AddScoped<ICardService, CardService>();
        services.AddScoped<IEmailService, EmailService>();
    }

    public void Configure(IApplicationBuilder app)
    {
        app.UseCors("AllowLocalhost3000");

        app.UseHttpsRedirection();
        app.UseRouting();

        app.UseAuthorization();

        app.UseEndpoints(endpoints =>
        {
            endpoints.MapControllers();
        });
    }
}
