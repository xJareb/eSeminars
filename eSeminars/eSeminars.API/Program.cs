using eSeminars.Services.Database;
using eSeminars.Services.Dojmovi;
using eSeminars.Services.Kategorije;
using eSeminars.Services.Korisnici;
using eSeminars.Services.Materijali;
using eSeminars.Services.Obavijesti;
using eSeminars.Services.Predavaci;
using eSeminars.Services.Rezervacije;
using eSeminars.Services.SacuvaniSeminari;
using eSeminars.Services.Seminari;
using eSeminars.Services.SeminariStateMachine;
using eSeminars.Services.Sponzori;
using eSeminars.Services.SponzoriSeminari;
using Mapster;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

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

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var connectionString = builder.Configuration.GetConnectionString("eSeminarsConnection");
builder.Services.AddDbContext<ESeminarsContext>(options =>
    options.UseSqlServer(connectionString));

builder.Services.AddMapster();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
