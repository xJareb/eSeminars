using eSeminars.Services.Database;
using eSeminars.Services.Kategorije;
using eSeminars.Services.Korisnici;
using eSeminars.Services.Obavijesti;
using eSeminars.Services.Predavaci;
using eSeminars.Services.Sponzori;
using Mapster;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddTransient<IPredavaciService, PredavaciService>();
builder.Services.AddTransient<IKategorijeService, KategorijeService>();
builder.Services.AddTransient<IKorisniciService,KorisniciService>();
builder.Services.AddTransient<IObavijestiService, ObavijestiService>();
builder.Services.AddTransient<ISponzoriService, SponzoriService>();

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
