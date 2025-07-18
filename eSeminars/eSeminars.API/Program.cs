using eSeminars.API;
using eSeminars.API.Filters;
using eSeminars.Services.Database;
using eSeminars.Services.Dojmovi;
using eSeminars.Services.Kategorije;
using eSeminars.Services.Korisnici;
using eSeminars.Services.Materijali;
using eSeminars.Services.Obavijesti;
using eSeminars.Services.Predavaci;
using eSeminars.Services.RabbitMQ;
using eSeminars.Services.Recommender;
using eSeminars.Services.Rezervacije;
using eSeminars.Services.RezervacijeStateMachine;
using eSeminars.Services.SacuvaniSeminari;
using eSeminars.Services.Seminari;
using eSeminars.Services.SeminariStateMachine;
using eSeminars.Services.Sponzori;
using eSeminars.Services.SponzoriSeminari;
using Mapster;
using Microsoft.AspNetCore.Authentication;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddHttpContextAccessor();

// Add services to the container.
builder.Services.AddTransient<IPredavaciService, PredavaciService>();
builder.Services.AddTransient<IKategorijeService, KategorijeService>();
builder.Services.AddTransient<IKorisniciService,KorisniciService>();
builder.Services.AddTransient<IObavijestiService, ObavijestiService>();
builder.Services.AddTransient<ISponzoriService, SponzoriService>();
builder.Services.AddTransient<ISeminariService, SeminariService>();
builder.Services.AddTransient<ISacuvaniSeminariService, SacuvaniSeminariService>();
builder.Services.AddTransient<IMaterijalService, MaterijaliService>();
builder.Services.AddTransient<IDojmoviService,DojmoviService>();
builder.Services.AddTransient<IRezervacijeService, RezervacijeService>();
builder.Services.AddTransient<ISponzoriSeminariService,SponzoriSeminariService>();


builder.Services.AddTransient<BaseSeminariState>();
builder.Services.AddTransient<InitialSeminariState>();
builder.Services.AddTransient<DraftSeminariState>();
builder.Services.AddTransient<ActiveSeminariState>();
builder.Services.AddTransient<HiddenSeminariState>();

builder.Services.AddTransient<BaseRezervacijeState>();
builder.Services.AddTransient<InitialRezervacijeState>();
builder.Services.AddTransient<PendingRezervacijeState>();
builder.Services.AddTransient<ApprovedRezervacijeState>();
builder.Services.AddTransient<RejectedRezervacijeState>();
builder.Services.AddScoped<IRabbitMQService, RabbitMQService>();
builder.Services.AddScoped<IRecommenderService, RecommenderService>();


builder.Services.AddControllers(
    x=> x.Filters.Add<ExceptionFilter>()
    );
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.AddSecurityDefinition("basicAuth", new Microsoft.OpenApi.Models.OpenApiSecurityScheme()
    {
        Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
        Scheme = "basic"
    });

    c.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement()
    {
    {
        new OpenApiSecurityScheme
        {
            Reference = new OpenApiReference{Type = ReferenceType.SecurityScheme, Id = "basicAuth"}
        },
        new string[]{}
    } });

});

var connectionString = builder.Configuration.GetConnectionString("eSeminarsConnection");
builder.Services.AddDbContext<ESeminarsContext>(options =>
    options.UseSqlServer(connectionString));

builder.Services.AddMapster();
builder.Services.AddAuthentication("BasicAuthentication").AddScheme<AuthenticationSchemeOptions,BasicAuthenticationHandler>("BasicAuthentication",null);

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}
app.UseCors(
    options => options
        .SetIsOriginAllowed(x => _ = true)
        .AllowAnyMethod()
        .AllowAnyHeader()
        .AllowCredentials()
);

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

using (var scope = app.Services.CreateScope())
{
    var dataContext = scope.ServiceProvider.GetRequiredService<ESeminarsContext>();
    //dataContext.Database.EnsureCreated();

    dataContext.Database.Migrate();
}

app.Run();
