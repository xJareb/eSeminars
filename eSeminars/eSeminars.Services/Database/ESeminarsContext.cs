using System;
using System.Collections.Generic;
using eSeminars.Model.Models;
using Microsoft.EntityFrameworkCore;

namespace eSeminars.Services.Database;

public partial class ESeminarsContext : DbContext
{
    public ESeminarsContext()
    {
    }

    public ESeminarsContext(DbContextOptions<ESeminarsContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Dojmovi> Dojmovis { get; set; }

    public virtual DbSet<Kategorije> Kategorijes { get; set; }

    public virtual DbSet<Korisnici> Korisnicis { get; set; }

    public virtual DbSet<Materijali> Materijalis { get; set; }

    public virtual DbSet<Obavijesti> Obavijestis { get; set; }

    public virtual DbSet<Predavaci> Predavacis { get; set; }

    public virtual DbSet<Rezervacije> Rezervacijes { get; set; }

    public virtual DbSet<SacuvaniSeminari> SacuvaniSeminaris { get; set; }

    public virtual DbSet<Seminari> Seminaris { get; set; }

    public virtual DbSet<Sponzori> Sponzoris { get; set; }

    public virtual DbSet<SponzoriSeminari> SponzoriSeminaris { get; set; }

    public virtual DbSet<Uloge> Uloges { get; set; }

//    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
//#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
//        => optionsBuilder.UseSqlServer("Data Source=localhost;Initial Catalog=eSeminars;Integrated Security=True;TrustServerCertificate=True");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Dojmovi>(entity =>
        {
            entity.HasKey(e => e.DojamId).HasName("PK__Dojmovi__FDF96C5061A3D04D");

            entity.ToTable("Dojmovi");

            entity.Property(e => e.DojamId).HasColumnName("DojamID");
            entity.Property(e => e.DatumKreiranjaDojma).HasColumnType("datetime");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.SeminarId).HasColumnName("SeminarID");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Dojmovis)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK__Dojmovi__Korisni__4D94879B");

            entity.HasOne(d => d.Seminar).WithMany(p => p.Dojmovis)
                .HasForeignKey(d => d.SeminarId)
                .HasConstraintName("FK__Dojmovi__Seminar__4CA06362");

            entity.HasData(
                new Dojmovi
                {
                    DojamId = 1,
                    SeminarId = 1,  // past seminar
                    KorisnikId = 3,
                    Ocjena = 5,
                    IsDeleted = false,
                    DatumKreiranjaDojma = DateTime.Now.AddDays(-20)
                },
                new Dojmovi
                {
                    DojamId = 2,
                    SeminarId = 2,  // past seminar
                    KorisnikId = 3,
                    Ocjena = 4,
                    IsDeleted = false,
                    DatumKreiranjaDojma = DateTime.Now.AddDays(-18)
                },
                new Dojmovi
                {
                    DojamId = 3,
                    SeminarId = 3,  // past seminar
                    KorisnikId = 3,
                    Ocjena = 3,
                    IsDeleted = false,
                    DatumKreiranjaDojma = DateTime.Now.AddDays(-15)
                },
                new Dojmovi
                {
                    DojamId = 4,
                    SeminarId = 4,  // past seminar
                    KorisnikId = 3,
                    Ocjena = 5,
                    IsDeleted = false,
                    DatumKreiranjaDojma = DateTime.Now.AddDays(-10)
                },
                new Dojmovi
                {
                    DojamId = 5,
                    SeminarId = 5,  // past seminar
                    KorisnikId = 3,
                    Ocjena = 4,
                    IsDeleted = false,
                    DatumKreiranjaDojma = DateTime.Now.AddDays(-5)
                });
        });

        modelBuilder.Entity<Kategorije>(entity =>
        {
            entity.HasKey(e => e.KategorijaId).HasName("PK__Kategori__6C3B8FCE05ED5B27");

            entity.ToTable("Kategorije");

            entity.Property(e => e.KategorijaId).HasColumnName("KategorijaID");
            entity.Property(e => e.IsDeleted)
                .HasDefaultValueSql("((0))")
                .HasColumnName("isDeleted");
            entity.Property(e => e.Naziv)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Opis)
                .HasMaxLength(255)
                .IsUnicode(false);

            entity.HasData(
                new Kategorije
                {
                    KategorijaId = 1,
                    Naziv = "Technology",
                    Opis = "Seminars focused on emerging technologies, programming, the IT industry, and innovations.",
                    IsDeleted = false
                },
                new Kategorije
                {
                    KategorijaId = 2,
                    Naziv = "Entrepreneurship",
                    Opis = "Educational content on starting, managing, and growing a business",
                    IsDeleted = false
                },
                new Kategorije
                {
                    KategorijaId = 3,
                    Naziv = "Health and Wellness",
                    Opis = "Topics related to physical and mental health, disease prevention, nutrition, and fitness.",
                    IsDeleted = false
                },
                new Kategorije
                {
                    KategorijaId = 4,
                    Naziv = "Education",
                    Opis = "Seminars for teachers, parents, and students aiming to improve education quality",
                    IsDeleted = false
                },
                new Kategorije
                {
                    KategorijaId = 5,
                    Naziv = "Personal Development",
                    Opis = "Focused on building communication, time management, public speaking",
                    IsDeleted = false
                }
                );
        });

        modelBuilder.Entity<Korisnici>(entity =>
        {
            entity.HasKey(e => e.KorisnikId).HasName("PK__Korisnic__80B06D612299F206");

            entity.ToTable("Korisnici");

            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.DatumRodjenja).HasColumnType("date");
            entity.Property(e => e.Email)
                .HasMaxLength(70)
                .IsUnicode(false);
            entity.Property(e => e.Ime)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.IsDeleted)
                .HasDefaultValueSql("((0))")
                .HasColumnName("isDeleted");
            entity.Property(e => e.LozinkaHash)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.LozinkaSalt)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Prezime)
                .HasMaxLength(50)
                .IsUnicode(false);

            entity.HasOne(d => d.UlogaNavigation).WithMany(p => p.Korisnicis)
                .HasForeignKey(d => d.Uloga)
                .HasConstraintName("FK__Korisnici__Uloga__3B75D760");

            entity.HasData(
                new Korisnici
                {
                    KorisnikId = 1,
                    Ime = "Admin",
                    Prezime = "Admin",
                    Email = "admin@gmail.com",
                    LozinkaHash = "uDJQzltg1+w1Hjhdktk4XbhuCrE=",
                    LozinkaSalt = "VBZIM52NwnqBQqr+Z84P9Q==",
                    Uloga = 1,
                    DatumRodjenja = new DateTime(2024, 5, 15),
                    IsDeleted = false
                },
                new Korisnici
                {
                    KorisnikId = 2,
                    Ime = "Organizator",
                    Prezime = "Organizator",
                    Email = "organizator@gmail.com",
                    LozinkaHash = "NVG/++BM466+Da6OgKZyptEKQP4=",
                    LozinkaSalt = "6ZA2IamCnGv7wLPfY3roQw==",
                    Uloga = 3,
                    DatumRodjenja = new DateTime(2024, 5, 15),
                    IsDeleted = false
                },
                new Korisnici
                {
                    KorisnikId = 3,
                    Ime = "Korisnik",
                    Prezime = "Korisnik",
                    Email = "korisnik@gmail.com",
                    LozinkaHash = "IYQP04iyzp/PgO854mbEzcUB+bE=",
                    LozinkaSalt = "+nykRTSHxp8hfVWKYjFt4w==",
                    Uloga = 2,
                    DatumRodjenja = new DateTime(2024, 5, 15),
                    IsDeleted = false
                }
                );
        });

        modelBuilder.Entity<Materijali>(entity =>
        {
            entity.HasKey(e => e.MaterijalId).HasName("PK__Materija__FB5CCBBD4A744600");

            entity.ToTable("Materijali");

            entity.Property(e => e.MaterijalId).HasColumnName("MaterijalID");
            entity.Property(e => e.DatumDodavanja).HasColumnType("datetime");
            entity.Property(e => e.IsDeleted)
                .HasDefaultValueSql("((0))")
                .HasColumnName("isDeleted");
            entity.Property(e => e.Naziv)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Putanja)
                .HasMaxLength(200)
                .IsUnicode(false);
            entity.Property(e => e.SeminarId).HasColumnName("SeminarID");

            entity.HasOne(d => d.Seminar).WithMany(p => p.Materijalis)
                .HasForeignKey(d => d.SeminarId)
                .HasConstraintName("FK__Materijal__Semin__5812160E");

            entity.HasData(
                new Materijali
                {
                    MaterijalId = 1,
                    SeminarId = 1,
                    Naziv = "Web Development Basics Slides",
                    Putanja = "materials/web_dev_basics.pdf",
                    DatumDodavanja = DateTime.Now.AddDays(-30),
                    IsDeleted = false
                },
                new Materijali
                {
                    MaterijalId = 2,
                    SeminarId = 2,
                    Naziv = "Startup Fundamentals Workbook",
                    Putanja = "materials/startup_fundamentals.docx",
                    DatumDodavanja = DateTime.Now.AddDays(-25),
                    IsDeleted = false
                },
                new Materijali
                {
                    MaterijalId = 3,
                    SeminarId = 3,
                    Naziv = "Nutrition & Mental Health Research",
                    Putanja = "materials/nutrition_mental_health.pdf",
                    DatumDodavanja = DateTime.Now.AddDays(-20),
                    IsDeleted = false
                },
                new Materijali
                {
                    MaterijalId = 4,
                    SeminarId = 4,
                    Naziv = "Innovative Teaching Methods Guide",
                    Putanja = "materials/teaching_methods_guide.pdf",
                    DatumDodavanja = DateTime.Now.AddDays(-15),
                    IsDeleted = false
                },
                new Materijali
                {
                    MaterijalId = 5,
                    SeminarId = 5,
                    Naziv = "Communication Skills Exercises",
                    Putanja = "materials/communication_skills.zip",
                    DatumDodavanja = DateTime.Now.AddDays(-10),
                    IsDeleted = false
                },
                new Materijali
                {
                    MaterijalId = 6,
                    SeminarId = 6,
                    Naziv = "Advanced JavaScript Examples",
                    Putanja = "materials/advanced_js_examples.zip",
                    DatumDodavanja = DateTime.Now.AddDays(-5),
                    IsDeleted = false
                },
                new Materijali
                {
                    MaterijalId = 7,
                    SeminarId = 7,
                    Naziv = "Funding Strategies Presentation",
                    Putanja = "materials/funding_strategies.pptx",
                    DatumDodavanja = DateTime.Now,
                    IsDeleted = false
                },
                new Materijali
                {
                    MaterijalId = 8,
                    SeminarId = 8,
                    Naziv = "Mindfulness Exercises",
                    Putanja = "materials/mindfulness_exercises.pdf",
                    DatumDodavanja = DateTime.Now,
                    IsDeleted = false
                },
                new Materijali
                {
                    MaterijalId = 9,
                    SeminarId = 9,
                    Naziv = "Blended Learning Resources",
                    Putanja = "materials/blended_learning_resources.pdf",
                    DatumDodavanja = DateTime.Now,
                    IsDeleted = false
                }
                );
        });

        modelBuilder.Entity<Obavijesti>(entity =>
        {
            entity.HasKey(e => e.ObavijestId).HasName("PK__Obavijes__99D330C0CEB7A3B7");

            entity.ToTable("Obavijesti");

            entity.Property(e => e.ObavijestId).HasColumnName("ObavijestID");
            entity.Property(e => e.DatumObavijesti).HasColumnType("datetime");
            entity.Property(e => e.IsDeleted)
                .HasDefaultValueSql("((0))")
                .HasColumnName("isDeleted");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.Naslov)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Sadrzaj)
                .HasMaxLength(200)
                .IsUnicode(false);

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Obavijestis)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK__Obavijest__Koris__5441852A");

            entity.HasData(new Obavijesti
            {
                ObavijestId = 1,
                Naslov = "Seminar Schedule Update",
                Sadrzaj = "The schedule for the upcoming seminars has been updated. Please check your email for details.",
                DatumObavijesti = DateTime.Now.AddDays(-3),
                KorisnikId = 1,
                IsDeleted = false
            },
            new Obavijesti
            {
                ObavijestId = 2,
                Naslov = "New Seminar Available",
                Sadrzaj = "A new seminar on 'Advanced JavaScript Concepts' has been added to the schedule.",
                DatumObavijesti = DateTime.Now.AddDays(-1),
                KorisnikId = 1,
                IsDeleted = false
            },
            new Obavijesti
            {
                ObavijestId = 3,
                Naslov = "Maintenance Downtime",
                Sadrzaj = "The system will undergo maintenance on July 10th from 1 AM to 3 AM. Services may be temporarily unavailable.",
                DatumObavijesti = DateTime.Now.AddDays(-7),
                KorisnikId = 1,
                IsDeleted = false
            },
            new Obavijesti
            {
                ObavijestId = 4,
                Naslov = "Feedback Request",
                Sadrzaj = "Please provide your feedback for the seminar you attended last week.",
                DatumObavijesti = DateTime.Now,
                KorisnikId = 1,
                IsDeleted = false
            });
        });

        modelBuilder.Entity<Predavaci>(entity =>
        {
            entity.HasKey(e => e.PredavacId).HasName("PK__Predavac__3C1813706CF8DCCA");

            entity.ToTable("Predavaci");

            entity.Property(e => e.PredavacId).HasColumnName("PredavacID");
            entity.Property(e => e.Biografija)
                .HasMaxLength(200)
                .IsUnicode(false);
            entity.Property(e => e.Email)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Ime)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.IsDeleted)
                .HasDefaultValueSql("((0))")
                .HasColumnName("isDeleted");
            entity.Property(e => e.Prezime)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Telefon)
                .HasMaxLength(50)
                .IsUnicode(false);

            entity.HasData(
                new Predavaci
                {
                    PredavacId = 1,
                    Ime = "Emily",
                    Prezime = "Johnson",
                    Biografija = "Experienced software engineer with a passion for teaching coding.",
                    Email = "emily.johnson@example.com",
                    Telefon = "12025550101",
                    IsDeleted = false
                }, new Predavaci
                {
                    PredavacId = 2,
                    Ime = "Michael",
                    Prezime = "Lee",
                    Biografija = "Startup mentor and entrepreneur with 10+ years of experience.",
                    Email = "michael.lee@example.com",
                    Telefon = "12025550123",
                    IsDeleted = false
                }, new Predavaci
                {
                    PredavacId = 3,
                    Ime = "Sophia",
                    Prezime = "Martinez",
                    Biografija = "Health coach focused on nutrition and mental well-being.",
                    Email = "sophia.martinez@example.com",
                    Telefon = "12025550188",
                    IsDeleted = false
                }, new Predavaci
                {
                    PredavacId = 4,
                    Ime = "David",
                    Prezime = "Nguyen",
                    Biografija = "Educator and public speaker specializing in effective teaching methods.",
                    Email = "david.nguyen@example.com",
                    Telefon = "12025550170",
                    IsDeleted = false
                }, new Predavaci
                {
                    PredavacId = 5,
                    Ime = "Olivia",
                    Prezime = "Brown",
                    Biografija = "Personal development trainer and leadership consultant.",
                    Email = "olivia.brown@example.com",
                    Telefon = "12025550135",
                    IsDeleted = false
                });
        });

        modelBuilder.Entity<Rezervacije>(entity =>
        {
            entity.HasKey(e => e.RezervacijaId).HasName("PK__Rezervac__CABA44FD7D67B779");

            entity.ToTable("Rezervacije");

            entity.Property(e => e.RezervacijaId).HasColumnName("RezervacijaID");
            entity.Property(e => e.DatumRezervacije).HasColumnType("datetime");
            entity.Property(e => e.IsDeleted)
                .HasDefaultValueSql("((0))")
                .HasColumnName("isDeleted");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.SeminarId).HasColumnName("SeminarID");
            entity.Property(e => e.StateMachine)
                .HasMaxLength(100)
                .IsUnicode(false);

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Rezervacijes)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK__Rezervaci__Koris__48CFD27E");

            entity.HasOne(d => d.Seminar).WithMany(p => p.Rezervacijes)
                .HasForeignKey(d => d.SeminarId)
                .HasConstraintName("FK__Rezervaci__Semin__47DBAE45");

            entity.HasData(new Rezervacije
            {
                RezervacijaId = 1,
                SeminarId = 1, // past seminar
                KorisnikId = 3,
                StateMachine = "approved",
                DatumRezervacije = DateTime.Now.AddMonths(-2),
                IsDeleted = false
            },
            new Rezervacije
            {
                RezervacijaId = 2,
                SeminarId = 2, // past seminar
                KorisnikId = 3,
                StateMachine = "approved",
                DatumRezervacije = DateTime.Now.AddMonths(-1).AddDays(-10),
                IsDeleted = false
            },
            new Rezervacije
            {
                RezervacijaId = 3,
                SeminarId = 3, // past seminar
                KorisnikId = 3,
                StateMachine = "approved",
                DatumRezervacije = DateTime.Now.AddMonths(-1),
                IsDeleted = false
            },
            new Rezervacije
            {
                RezervacijaId = 4,
                SeminarId = 7, // future seminar
                KorisnikId = 3,
                StateMachine = "pending",
                DatumRezervacije = DateTime.Now.AddDays(-5),
                IsDeleted = false
            },
            new Rezervacije
            {
                RezervacijaId = 5,
                SeminarId = 8, // future seminar
                KorisnikId = 3,
                StateMachine = "pending",
                DatumRezervacije = DateTime.Now.AddDays(-3),
                IsDeleted = false
            },
            new Rezervacije
            {
                RezervacijaId = 6,
                SeminarId = 10, // future seminar
                KorisnikId = 3,
                StateMachine = "pending",
                DatumRezervacije = DateTime.Now,
                IsDeleted = false
            });
        });

        modelBuilder.Entity<SacuvaniSeminari>(entity =>
        {
            entity.HasKey(e => e.SacuvaniSeminarId).HasName("PK__Sacuvani__0437E3BFA7AB7A53");

            entity.ToTable("SacuvaniSeminari");

            entity.Property(e => e.SacuvaniSeminarId).HasColumnName("SacuvaniSeminarID");
            entity.Property(e => e.DatumSacuvanja).HasColumnType("datetime");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.SeminarId).HasColumnName("SeminarID");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.SacuvaniSeminaris)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK__SacuvaniS__Koris__5070F446");

            entity.HasOne(d => d.Seminar).WithMany(p => p.SacuvaniSeminaris)
                .HasForeignKey(d => d.SeminarId)
                .HasConstraintName("FK__SacuvaniS__Semin__5165187F");

            entity.HasData(
                new SacuvaniSeminari
                {
                    SacuvaniSeminarId = 1,
                    KorisnikId = 3,
                    SeminarId = 2,
                    DatumSacuvanja = DateTime.Now.AddDays(-10),
                    IsDeleted = false
                },
                new SacuvaniSeminari
                {
                    SacuvaniSeminarId = 2,
                    KorisnikId = 3,
                    SeminarId = 5,
                    DatumSacuvanja = DateTime.Now.AddDays(-5),
                    IsDeleted = false
                },
                new SacuvaniSeminari
                {
                    SacuvaniSeminarId = 3,
                    KorisnikId = 3,
                    SeminarId = 8,
                    DatumSacuvanja = DateTime.Now,
                    IsDeleted = false
                });
        });

        modelBuilder.Entity<Seminari>(entity =>
        {
            entity.HasKey(e => e.SeminarId).HasName("PK__Seminari__66BB8935083EE2D6");

            entity.ToTable("Seminari");

            entity.Property(e => e.SeminarId).HasColumnName("SeminarID");
            entity.Property(e => e.DatumKreiranja).HasColumnType("datetime");
            entity.Property(e => e.DatumVrijeme).HasColumnType("datetime");
            entity.Property(e => e.IsDeleted)
                .HasDefaultValueSql("((0))")
                .HasColumnName("isDeleted");
            entity.Property(e => e.KategorijaId).HasColumnName("KategorijaID");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.Lokacija)
                .HasMaxLength(200)
                .IsUnicode(false);
            entity.Property(e => e.Naslov)
                .HasMaxLength(200)
                .IsUnicode(false);
            entity.Property(e => e.Opis)
                .HasMaxLength(200)
                .IsUnicode(false);
            entity.Property(e => e.PredavacId).HasColumnName("PredavacID");
            entity.Property(e => e.StateMachine)
                .HasMaxLength(100)
                .IsUnicode(false);

            entity.HasOne(d => d.Kategorija).WithMany(p => p.Seminaris)
                .HasForeignKey(d => d.KategorijaId)
                .HasConstraintName("FK__Seminari__Katego__440B1D61");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Seminaris)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK__Seminari__Korisn__4222D4EF");

            entity.HasOne(d => d.Predavac).WithMany(p => p.Seminaris)
                .HasForeignKey(d => d.PredavacId)
                .HasConstraintName("FK__Seminari__Predav__4316F928");

            entity.HasData(
                new Seminari
                {
                    SeminarId = 1,
                    Naslov = "Introduction to Modern Web Development",
                    Opis = "Learn the basics of HTML, CSS, and JavaScript.",
                    DatumVrijeme = new DateTime(2024, 12, 10, 10, 0, 0),
                    Lokacija = "Conference Room A",
                    Kapacitet = 50,
                    Zauzeti = 0,
                    StateMachine = "active",
                    PredavacId = 1,
                    KorisnikId = 2,
                    KategorijaId = 1,
                    DatumKreiranja = DateTime.Now.AddMonths(-6),
                    IsDeleted = false
                },
                new Seminari
                {
                    SeminarId = 2,
                    Naslov = "Startup Fundamentals",
                    Opis = "Essential knowledge for launching your own business.",
                    DatumVrijeme = new DateTime(2025, 1, 15, 14, 0, 0),
                    Lokacija = "Conference Room B",
                    Kapacitet = 40,
                    Zauzeti = 0,
                    StateMachine = "active",
                    PredavacId = 2,
                    KorisnikId = 2,
                    KategorijaId = 2,
                    DatumKreiranja = DateTime.Now.AddMonths(-5),
                    IsDeleted = false
                }, new Seminari
                {
                    SeminarId = 3,
                    Naslov = "Nutrition and Mental Health",
                    Opis = "Discover how diet affects your mind and body.",
                    DatumVrijeme = new DateTime(2025, 3, 20, 9, 30, 0), // past
                    Lokacija = "Conference Room C",
                    Kapacitet = 60,
                    Zauzeti = 0,
                    StateMachine = "active",
                    PredavacId = 3,
                    KorisnikId = 2,
                    KategorijaId = 3,
                    DatumKreiranja = DateTime.Now.AddMonths(-4),
                    IsDeleted = false
                }, new Seminari
                {
                    SeminarId = 4,
                    Naslov = "Innovative Teaching Techniques",
                    Opis = "Improve your teaching skills with new methods.",
                    DatumVrijeme = new DateTime(2025, 4, 22, 13, 0, 0), // past
                    Lokacija = "Conference Room D",
                    Kapacitet = 30,
                    Zauzeti = 0,
                    StateMachine = "active",
                    PredavacId = 4,
                    KorisnikId = 2,
                    KategorijaId = 4,
                    DatumKreiranja = DateTime.Now.AddMonths(-3),
                    IsDeleted = false
                }, new Seminari
                {
                    SeminarId = 5,
                    Naslov = "Effective Communication Skills",
                    Opis = "Learn how to communicate clearly and confidently.",
                    DatumVrijeme = new DateTime(2025, 12, 25, 11, 0, 0), // future
                    Lokacija = "Conference Room E",
                    Kapacitet = 45,
                    Zauzeti = 0,
                    StateMachine = "active",
                    PredavacId = 5,
                    KorisnikId = 2,
                    KategorijaId = 5,
                    DatumKreiranja = DateTime.Now,
                    IsDeleted = false
                }, new Seminari
                {
                    SeminarId = 6,
                    Naslov = "Advanced JavaScript Concepts",
                    Opis = "Deep dive into closures, prototypes, and async programming.",
                    DatumVrijeme = new DateTime(2025, 12, 30, 10, 0, 0), // future
                    Lokacija = "Conference Room A",
                    Kapacitet = 50,
                    Zauzeti = 0,
                    StateMachine = "active",
                    PredavacId = 1,
                    KorisnikId = 2,
                    KategorijaId = 1,
                    DatumKreiranja = DateTime.Now,
                    IsDeleted = false
                }, new Seminari
                {
                    SeminarId = 7,
                    Naslov = "Funding Your Startup",
                    Opis = "Explore strategies for raising capital.",
                    DatumVrijeme = new DateTime(2026, 1, 3, 14, 0, 0), // future
                    Lokacija = "Conference Room B",
                    Kapacitet = 40,
                    Zauzeti = 0,
                    StateMachine = "active",
                    PredavacId = 2,
                    KorisnikId = 2,
                    KategorijaId = 2,
                    DatumKreiranja = DateTime.Now,
                    IsDeleted = false
                }, new Seminari
                {
                    SeminarId = 8,
                    Naslov = "Mindfulness and Stress Reduction",
                    Opis = "Techniques to improve mental wellness.",
                    DatumVrijeme = new DateTime(2026, 1, 5, 9, 30, 0), // future
                    Lokacija = "Conference Room C",
                    Kapacitet = 60,
                    Zauzeti = 0,
                    StateMachine = "active",
                    PredavacId = 3,
                    KorisnikId = 2,
                    KategorijaId = 3,
                    DatumKreiranja = DateTime.Now,
                    IsDeleted = false
                }, new Seminari
                {
                    SeminarId = 9,
                    Naslov = "Blended Learning Models",
                    Opis = "Combine online and in-person teaching effectively.",
                    DatumVrijeme = new DateTime(2026, 1, 7, 13, 0, 0), // future
                    Lokacija = "Conference Room D",
                    Kapacitet = 30,
                    Zauzeti = 0,
                    StateMachine = "active",
                    PredavacId = 4,
                    KorisnikId = 2,
                    KategorijaId = 4,
                    DatumKreiranja = DateTime.Now,
                    IsDeleted = false
                }, new Seminari
                {
                    SeminarId = 10,
                    Naslov = "Time Management Strategies",
                    Opis = "Boost productivity with smart planning.",
                    DatumVrijeme = new DateTime(2026, 1, 10, 11, 0, 0), // future
                    Lokacija = "Conference Room E",
                    Kapacitet = 45,
                    Zauzeti = 0,
                    StateMachine = "active",
                    PredavacId = 5,
                    KorisnikId = 2,
                    KategorijaId = 5,
                    DatumKreiranja = DateTime.Now,
                    IsDeleted = false
                });
        });

        modelBuilder.Entity<Sponzori>(entity =>
        {
            entity.HasKey(e => e.SponzorId).HasName("PK__Sponzori__8161C49A1E97374F");

            entity.ToTable("Sponzori");

            entity.Property(e => e.SponzorId).HasColumnName("SponzorID");
            entity.Property(e => e.Email)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.IsDeleted)
                .HasDefaultValueSql("((0))")
                .HasColumnName("isDeleted");
            entity.Property(e => e.KontaktOsoba)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Naziv)
                .HasMaxLength(200)
                .IsUnicode(false);
            entity.Property(e => e.Telefon)
                .HasMaxLength(50)
                .IsUnicode(false);

            entity.HasData(
                new Sponzori
                {
                    SponzorId = 1,
                    Naziv = "TechNova Inc.",
                    Email = "contact@technova.com",
                    Telefon = "2025550191",
                    KontaktOsoba = "Laura Smith",
                    IsDeleted = false
                },
                new Sponzori
                {
                    SponzorId = 2,
                    Naziv = "GreenHealth Foundation",
                    Email = "info@greenhealth.org",
                    Telefon = "2025550142",
                    KontaktOsoba = "James Taylor",
                    IsDeleted = false
                }, new Sponzori
                {
                    SponzorId = 3,
                    Naziv = "EduFuture Alliance",
                    Email = "support@edufuture.com",
                    Telefon = "2025550177",
                    KontaktOsoba = "Anna Williams",
                    IsDeleted = false
                }, new Sponzori
                {
                    SponzorId = 4,
                    Naziv = "WellBeing Co.",
                    Email = "hello@wellbeingco.com",
                    Telefon = "2025550165",
                    KontaktOsoba = "Robert Johnson",
                    IsDeleted = false
                },
                new Sponzori
                {
                    SponzorId = 5,
                    Naziv = "InnovaLab",
                    Email = "partners@innovalab.io",
                    Telefon = "2025550119",
                    KontaktOsoba = "Emily Davis",
                    IsDeleted = false
                });
        });

        modelBuilder.Entity<SponzoriSeminari>(entity =>
        {
            entity.HasKey(e => e.SponzoriSeminariId).HasName("PK__Sponzori__BF5AC3214370BF0F");

            entity.ToTable("SponzoriSeminari");

            entity.Property(e => e.SponzoriSeminariId).HasColumnName("SponzoriSeminariID");
            entity.Property(e => e.SeminarId).HasColumnName("SeminarID");
            entity.Property(e => e.SponzorId).HasColumnName("SponzorID");

            entity.HasOne(d => d.Seminar).WithMany(p => p.SponzoriSeminaris)
                .HasForeignKey(d => d.SeminarId)
                .HasConstraintName("FK__SponzoriS__Semin__5EBF139D");

            entity.HasOne(d => d.Sponzor).WithMany(p => p.SponzoriSeminaris)
                .HasForeignKey(d => d.SponzorId)
                .HasConstraintName("FK__SponzoriS__Sponz__5FB337D6");

            entity.HasData(
                new SponzoriSeminari
                {
                    SponzoriSeminariId = 1,
                    SeminarId = 1,
                    SponzorId = 1,
                    IsDeleted = false
                },
                new SponzoriSeminari
                {
                    SponzoriSeminariId = 2,
                    SeminarId = 2,
                    SponzorId = 2,
                    IsDeleted = false
                },
                new SponzoriSeminari
                {
                    SponzoriSeminariId = 3,
                    SeminarId = 3,
                    SponzorId = 3,
                    IsDeleted = false
                },
                new SponzoriSeminari
                {
                    SponzoriSeminariId = 4,
                    SeminarId = 4,
                    SponzorId = 1,
                    IsDeleted = false
                },
                new SponzoriSeminari
                {
                    SponzoriSeminariId = 5,
                    SeminarId = 5,
                    SponzorId = 4,
                    IsDeleted = false
                },
                new SponzoriSeminari
                {
                    SponzoriSeminariId = 6,
                    SeminarId = 6,
                    SponzorId = 2,
                    IsDeleted = false
                },
                new SponzoriSeminari
                {
                    SponzoriSeminariId = 7,
                    SeminarId = 7,
                    SponzorId = 3,
                    IsDeleted = false
                },
                new SponzoriSeminari
                {
                    SponzoriSeminariId = 8,
                    SeminarId = 8,
                    SponzorId = 5,
                    IsDeleted = false
                },
                new SponzoriSeminari
                {
                    SponzoriSeminariId = 9,
                    SeminarId = 9,
                    SponzorId = 4,
                    IsDeleted = false
                },
                new SponzoriSeminari
                {
                    SponzoriSeminariId = 10,
                    SeminarId = 10,
                    SponzorId = 5,
                    IsDeleted = false
                });
        });

        modelBuilder.Entity<Uloge>(entity =>
        {
            entity.HasKey(e => e.UlogaId).HasName("PK__Uloge__DCAB23EBA5488EF0");

            entity.ToTable("Uloge");

            entity.Property(e => e.UlogaId).HasColumnName("UlogaID");
            entity.Property(e => e.Naziv)
                .HasMaxLength(100)
                .IsUnicode(false);

            entity.HasData(
            new Uloge { UlogaId = 1, Naziv = "Administrator" },
            new Uloge { UlogaId = 2, Naziv = "Korisnik" },
            new Uloge { UlogaId = 3, Naziv = "Organizator" }
            );
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
