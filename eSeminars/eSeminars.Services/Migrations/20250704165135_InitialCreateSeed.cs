using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace eSeminars.Services.Migrations
{
    /// <inheritdoc />
    public partial class InitialCreateSeed : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Kategorije",
                columns: table => new
                {
                    KategorijaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: false),
                    Opis = table.Column<string>(type: "varchar(255)", unicode: false, maxLength: 255, nullable: false),
                    isDeleted = table.Column<bool>(type: "bit", nullable: true, defaultValueSql: "((0))")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Kategori__6C3B8FCE05ED5B27", x => x.KategorijaID);
                });

            migrationBuilder.CreateTable(
                name: "Predavaci",
                columns: table => new
                {
                    PredavacID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Ime = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    Prezime = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    Biografija = table.Column<string>(type: "varchar(200)", unicode: false, maxLength: 200, nullable: false),
                    Email = table.Column<string>(type: "varchar(70)", unicode: false, maxLength: 70, nullable: false),
                    Telefon = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    isDeleted = table.Column<bool>(type: "bit", nullable: true, defaultValueSql: "((0))")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Predavac__3C1813706CF8DCCA", x => x.PredavacID);
                });

            migrationBuilder.CreateTable(
                name: "Sponzori",
                columns: table => new
                {
                    SponzorID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "varchar(200)", unicode: false, maxLength: 200, nullable: false),
                    Email = table.Column<string>(type: "varchar(70)", unicode: false, maxLength: 70, nullable: false),
                    Telefon = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    KontaktOsoba = table.Column<string>(type: "varchar(70)", unicode: false, maxLength: 70, nullable: false),
                    isDeleted = table.Column<bool>(type: "bit", nullable: true, defaultValueSql: "((0))")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Sponzori__8161C49A1E97374F", x => x.SponzorID);
                });

            migrationBuilder.CreateTable(
                name: "Uloge",
                columns: table => new
                {
                    UlogaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Uloge__DCAB23EBA5488EF0", x => x.UlogaID);
                });

            migrationBuilder.CreateTable(
                name: "Korisnici",
                columns: table => new
                {
                    KorisnikID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Ime = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    Prezime = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    Email = table.Column<string>(type: "varchar(70)", unicode: false, maxLength: 70, nullable: false),
                    LozinkaHash = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    LozinkaSalt = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    Uloga = table.Column<int>(type: "int", nullable: true),
                    DatumRodjenja = table.Column<DateTime>(type: "date", nullable: false),
                    isDeleted = table.Column<bool>(type: "bit", nullable: true, defaultValueSql: "((0))")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Korisnic__80B06D612299F206", x => x.KorisnikID);
                    table.ForeignKey(
                        name: "FK__Korisnici__Uloga__3B75D760",
                        column: x => x.Uloga,
                        principalTable: "Uloge",
                        principalColumn: "UlogaID");
                });

            migrationBuilder.CreateTable(
                name: "Obavijesti",
                columns: table => new
                {
                    ObavijestID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naslov = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: false),
                    Sadrzaj = table.Column<string>(type: "varchar(200)", unicode: false, maxLength: 200, nullable: false),
                    DatumObavijesti = table.Column<DateTime>(type: "datetime", nullable: false),
                    KorisnikID = table.Column<int>(type: "int", nullable: true),
                    isDeleted = table.Column<bool>(type: "bit", nullable: true, defaultValueSql: "((0))")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Obavijes__99D330C0CEB7A3B7", x => x.ObavijestID);
                    table.ForeignKey(
                        name: "FK__Obavijest__Koris__5441852A",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikID");
                });

            migrationBuilder.CreateTable(
                name: "Seminari",
                columns: table => new
                {
                    SeminarID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naslov = table.Column<string>(type: "varchar(200)", unicode: false, maxLength: 200, nullable: false),
                    Opis = table.Column<string>(type: "varchar(200)", unicode: false, maxLength: 200, nullable: false),
                    DatumVrijeme = table.Column<DateTime>(type: "datetime", nullable: false),
                    Lokacija = table.Column<string>(type: "varchar(200)", unicode: false, maxLength: 200, nullable: false),
                    Kapacitet = table.Column<int>(type: "int", nullable: false),
                    Zauzeti = table.Column<int>(type: "int", nullable: false),
                    StateMachine = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: true),
                    KorisnikID = table.Column<int>(type: "int", nullable: true),
                    PredavacID = table.Column<int>(type: "int", nullable: true),
                    DatumKreiranja = table.Column<DateTime>(type: "datetime", nullable: false),
                    KategorijaID = table.Column<int>(type: "int", nullable: true),
                    isDeleted = table.Column<bool>(type: "bit", nullable: true, defaultValueSql: "((0))")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Seminari__66BB8935083EE2D6", x => x.SeminarID);
                    table.ForeignKey(
                        name: "FK__Seminari__Katego__440B1D61",
                        column: x => x.KategorijaID,
                        principalTable: "Kategorije",
                        principalColumn: "KategorijaID");
                    table.ForeignKey(
                        name: "FK__Seminari__Korisn__4222D4EF",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikID");
                    table.ForeignKey(
                        name: "FK__Seminari__Predav__4316F928",
                        column: x => x.PredavacID,
                        principalTable: "Predavaci",
                        principalColumn: "PredavacID");
                });

            migrationBuilder.CreateTable(
                name: "Dojmovi",
                columns: table => new
                {
                    DojamID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    SeminarID = table.Column<int>(type: "int", nullable: true),
                    KorisnikID = table.Column<int>(type: "int", nullable: true),
                    Ocjena = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: true),
                    DatumKreiranjaDojma = table.Column<DateTime>(type: "datetime", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Dojmovi__FDF96C5061A3D04D", x => x.DojamID);
                    table.ForeignKey(
                        name: "FK__Dojmovi__Korisni__4D94879B",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikID");
                    table.ForeignKey(
                        name: "FK__Dojmovi__Seminar__4CA06362",
                        column: x => x.SeminarID,
                        principalTable: "Seminari",
                        principalColumn: "SeminarID");
                });

            migrationBuilder.CreateTable(
                name: "Materijali",
                columns: table => new
                {
                    MaterijalID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    SeminarID = table.Column<int>(type: "int", nullable: true),
                    Naziv = table.Column<string>(type: "varchar(70)", unicode: false, maxLength: 70, nullable: false),
                    Putanja = table.Column<string>(type: "varchar(200)", unicode: false, maxLength: 200, nullable: false),
                    DatumDodavanja = table.Column<DateTime>(type: "datetime", nullable: false),
                    isDeleted = table.Column<bool>(type: "bit", nullable: true, defaultValueSql: "((0))")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Materija__FB5CCBBD4A744600", x => x.MaterijalID);
                    table.ForeignKey(
                        name: "FK__Materijal__Semin__5812160E",
                        column: x => x.SeminarID,
                        principalTable: "Seminari",
                        principalColumn: "SeminarID");
                });

            migrationBuilder.CreateTable(
                name: "Rezervacije",
                columns: table => new
                {
                    RezervacijaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    SeminarID = table.Column<int>(type: "int", nullable: true),
                    KorisnikID = table.Column<int>(type: "int", nullable: true),
                    StateMachine = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: true),
                    DatumRezervacije = table.Column<DateTime>(type: "datetime", nullable: false),
                    isDeleted = table.Column<bool>(type: "bit", nullable: true, defaultValueSql: "((0))")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Rezervac__CABA44FD7D67B779", x => x.RezervacijaID);
                    table.ForeignKey(
                        name: "FK__Rezervaci__Koris__48CFD27E",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikID");
                    table.ForeignKey(
                        name: "FK__Rezervaci__Semin__47DBAE45",
                        column: x => x.SeminarID,
                        principalTable: "Seminari",
                        principalColumn: "SeminarID");
                });

            migrationBuilder.CreateTable(
                name: "SacuvaniSeminari",
                columns: table => new
                {
                    SacuvaniSeminarID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikID = table.Column<int>(type: "int", nullable: true),
                    SeminarID = table.Column<int>(type: "int", nullable: true),
                    DatumSacuvanja = table.Column<DateTime>(type: "datetime", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Sacuvani__0437E3BFA7AB7A53", x => x.SacuvaniSeminarID);
                    table.ForeignKey(
                        name: "FK__SacuvaniS__Koris__5070F446",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikID");
                    table.ForeignKey(
                        name: "FK__SacuvaniS__Semin__5165187F",
                        column: x => x.SeminarID,
                        principalTable: "Seminari",
                        principalColumn: "SeminarID");
                });

            migrationBuilder.CreateTable(
                name: "SponzoriSeminari",
                columns: table => new
                {
                    SponzoriSeminariID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    SeminarID = table.Column<int>(type: "int", nullable: true),
                    SponzorID = table.Column<int>(type: "int", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Sponzori__BF5AC3214370BF0F", x => x.SponzoriSeminariID);
                    table.ForeignKey(
                        name: "FK__SponzoriS__Semin__5EBF139D",
                        column: x => x.SeminarID,
                        principalTable: "Seminari",
                        principalColumn: "SeminarID");
                    table.ForeignKey(
                        name: "FK__SponzoriS__Sponz__5FB337D6",
                        column: x => x.SponzorID,
                        principalTable: "Sponzori",
                        principalColumn: "SponzorID");
                });

            migrationBuilder.InsertData(
                table: "Kategorije",
                columns: new[] { "KategorijaID", "isDeleted", "Naziv", "Opis" },
                values: new object[,]
                {
                    { 1, false, "Technology", "Seminars focused on emerging technologies, programming, the IT industry, and innovations." },
                    { 2, false, "Entrepreneurship", "Educational content on starting, managing, and growing a business" },
                    { 3, false, "Health and Wellness", "Topics related to physical and mental health, disease prevention, nutrition, and fitness." },
                    { 4, false, "Education", "Seminars for teachers, parents, and students aiming to improve education quality" },
                    { 5, false, "Personal Development", "Focused on building communication, time management, public speaking" }
                });

            migrationBuilder.InsertData(
                table: "Predavaci",
                columns: new[] { "PredavacID", "Biografija", "Email", "Ime", "isDeleted", "Prezime", "Telefon" },
                values: new object[,]
                {
                    { 1, "Experienced software engineer with a passion for teaching coding.", "emily.johnson@example.com", "Emily", false, "Johnson", "12025550101" },
                    { 2, "Startup mentor and entrepreneur with 10+ years of experience.", "michael.lee@example.com", "Michael", false, "Lee", "12025550123" },
                    { 3, "Health coach focused on nutrition and mental well-being.", "sophia.martinez@example.com", "Sophia", false, "Martinez", "12025550188" },
                    { 4, "Educator and public speaker specializing in effective teaching methods.", "david.nguyen@example.com", "David", false, "Nguyen", "12025550170" },
                    { 5, "Personal development trainer and leadership consultant.", "olivia.brown@example.com", "Olivia", false, "Brown", "12025550135" }
                });

            migrationBuilder.InsertData(
                table: "Sponzori",
                columns: new[] { "SponzorID", "Email", "isDeleted", "KontaktOsoba", "Naziv", "Telefon" },
                values: new object[,]
                {
                    { 1, "contact@technova.com", false, "Laura Smith", "TechNova Inc.", "2025550191" },
                    { 2, "info@greenhealth.org", false, "James Taylor", "GreenHealth Foundation", "2025550142" },
                    { 3, "support@edufuture.com", false, "Anna Williams", "EduFuture Alliance", "2025550177" },
                    { 4, "hello@wellbeingco.com", false, "Robert Johnson", "WellBeing Co.", "2025550165" },
                    { 5, "partners@innovalab.io", false, "Emily Davis", "InnovaLab", "2025550119" }
                });

            migrationBuilder.InsertData(
                table: "Uloge",
                columns: new[] { "UlogaID", "Naziv" },
                values: new object[,]
                {
                    { 1, "Administrator" },
                    { 2, "Korisnik" },
                    { 3, "Organizator" }
                });

            migrationBuilder.InsertData(
                table: "Korisnici",
                columns: new[] { "KorisnikID", "DatumRodjenja", "Email", "Ime", "isDeleted", "LozinkaHash", "LozinkaSalt", "Prezime", "Uloga" },
                values: new object[,]
                {
                    { 1, new DateTime(2024, 5, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), "admin@gmail.com", "Admin", false, "uDJQzltg1+w1Hjhdktk4XbhuCrE=", "VBZIM52NwnqBQqr+Z84P9Q==", "Admin", 1 },
                    { 2, new DateTime(2024, 5, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), "organizator@gmail.com", "Organizator", false, "NVG/++BM466+Da6OgKZyptEKQP4=", "6ZA2IamCnGv7wLPfY3roQw==", "Organizator", 3 },
                    { 3, new DateTime(2024, 5, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), "korisnik@gmail.com", "Korisnik", false, "IYQP04iyzp/PgO854mbEzcUB+bE=", "+nykRTSHxp8hfVWKYjFt4w==", "Korisnik", 2 },
                    { 4, new DateTime(1995, 6, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), "leon.savic@gmail.com", "Leon", false, "Hash4=", "Salt4==", "Savić", 2 },
                    { 5, new DateTime(1997, 11, 3, 0, 0, 0, 0, DateTimeKind.Unspecified), "marija.kova@gmail.com", "Marija", false, "Hash5=", "Salt5==", "Kovačević", 2 },
                    { 6, new DateTime(2000, 2, 28, 0, 0, 0, 0, DateTimeKind.Unspecified), "nemanja.jox@gmail.com", "Nemanja", false, "Hash6=", "Salt6==", "Jovanović", 2 }
                });

            migrationBuilder.InsertData(
                table: "Obavijesti",
                columns: new[] { "ObavijestID", "DatumObavijesti", "isDeleted", "KorisnikID", "Naslov", "Sadrzaj" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 7, 1, 18, 51, 35, 725, DateTimeKind.Local).AddTicks(7283), false, 1, "Seminar Schedule Update", "The schedule for the upcoming seminars has been updated. Please check your email for details." },
                    { 2, new DateTime(2025, 7, 3, 18, 51, 35, 725, DateTimeKind.Local).AddTicks(7301), false, 1, "New Seminar Available", "A new seminar on 'Advanced JavaScript Concepts' has been added to the schedule." },
                    { 3, new DateTime(2025, 6, 27, 18, 51, 35, 725, DateTimeKind.Local).AddTicks(7304), false, 1, "Maintenance Downtime", "The system will undergo maintenance on July 10th from 1 AM to 3 AM. Services may be temporarily unavailable." },
                    { 4, new DateTime(2025, 7, 4, 18, 51, 35, 725, DateTimeKind.Local).AddTicks(7307), false, 1, "Feedback Request", "Please provide your feedback for the seminar you attended last week." }
                });

            migrationBuilder.InsertData(
                table: "Seminari",
                columns: new[] { "SeminarID", "DatumKreiranja", "DatumVrijeme", "isDeleted", "Kapacitet", "KategorijaID", "KorisnikID", "Lokacija", "Naslov", "Opis", "PredavacID", "StateMachine", "Zauzeti" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 1, 4, 18, 51, 35, 727, DateTimeKind.Local).AddTicks(5726), new DateTime(2024, 12, 10, 10, 0, 0, 0, DateTimeKind.Unspecified), false, 50, 1, 2, "Conference Room A", "Introduction to Modern Web Development", "Learn the basics of HTML, CSS, and JavaScript.", 1, "active", 0 },
                    { 2, new DateTime(2025, 2, 4, 18, 51, 35, 727, DateTimeKind.Local).AddTicks(5748), new DateTime(2025, 1, 15, 14, 0, 0, 0, DateTimeKind.Unspecified), false, 40, 2, 2, "Conference Room B", "Startup Fundamentals", "Essential knowledge for launching your own business.", 2, "active", 0 },
                    { 3, new DateTime(2025, 3, 4, 18, 51, 35, 727, DateTimeKind.Local).AddTicks(5752), new DateTime(2025, 3, 20, 9, 30, 0, 0, DateTimeKind.Unspecified), false, 60, 3, 2, "Conference Room C", "Nutrition and Mental Health", "Discover how diet affects your mind and body.", 3, "active", 0 },
                    { 4, new DateTime(2025, 4, 4, 18, 51, 35, 727, DateTimeKind.Local).AddTicks(5756), new DateTime(2025, 4, 22, 13, 0, 0, 0, DateTimeKind.Unspecified), false, 30, 4, 2, "Conference Room D", "Innovative Teaching Techniques", "Improve your teaching skills with new methods.", 4, "active", 0 },
                    { 5, new DateTime(2025, 7, 4, 18, 51, 35, 727, DateTimeKind.Local).AddTicks(5760), new DateTime(2025, 12, 25, 11, 0, 0, 0, DateTimeKind.Unspecified), false, 45, 5, 2, "Conference Room E", "Effective Communication Skills", "Learn how to communicate clearly and confidently.", 5, "active", 0 },
                    { 6, new DateTime(2025, 7, 4, 18, 51, 35, 727, DateTimeKind.Local).AddTicks(5765), new DateTime(2025, 12, 30, 10, 0, 0, 0, DateTimeKind.Unspecified), false, 50, 1, 2, "Conference Room A", "Advanced JavaScript Concepts", "Deep dive into closures, prototypes, and async programming.", 1, "active", 0 },
                    { 7, new DateTime(2025, 7, 4, 18, 51, 35, 727, DateTimeKind.Local).AddTicks(5769), new DateTime(2026, 1, 3, 14, 0, 0, 0, DateTimeKind.Unspecified), false, 40, 2, 2, "Conference Room B", "Funding Your Startup", "Explore strategies for raising capital.", 2, "active", 0 },
                    { 8, new DateTime(2025, 7, 4, 18, 51, 35, 727, DateTimeKind.Local).AddTicks(5803), new DateTime(2026, 1, 5, 9, 30, 0, 0, DateTimeKind.Unspecified), false, 60, 3, 2, "Conference Room C", "Mindfulness and Stress Reduction", "Techniques to improve mental wellness.", 3, "active", 0 },
                    { 9, new DateTime(2025, 7, 4, 18, 51, 35, 727, DateTimeKind.Local).AddTicks(5808), new DateTime(2026, 1, 7, 13, 0, 0, 0, DateTimeKind.Unspecified), false, 30, 4, 2, "Conference Room D", "Blended Learning Models", "Combine online and in-person teaching effectively.", 4, "active", 0 },
                    { 10, new DateTime(2025, 7, 4, 18, 51, 35, 727, DateTimeKind.Local).AddTicks(5811), new DateTime(2026, 1, 10, 11, 0, 0, 0, DateTimeKind.Unspecified), false, 45, 5, 2, "Conference Room E", "Time Management Strategies", "Boost productivity with smart planning.", 5, "active", 0 }
                });

            migrationBuilder.InsertData(
                table: "Dojmovi",
                columns: new[] { "DojamID", "DatumKreiranjaDojma", "IsDeleted", "KorisnikID", "Ocjena", "SeminarID" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 6, 14, 18, 51, 35, 723, DateTimeKind.Local).AddTicks(6670), false, 3, 5, 1 },
                    { 2, new DateTime(2025, 6, 16, 18, 51, 35, 723, DateTimeKind.Local).AddTicks(6720), false, 4, 4, 1 },
                    { 3, new DateTime(2025, 6, 18, 18, 51, 35, 723, DateTimeKind.Local).AddTicks(6725), false, 5, 5, 2 },
                    { 4, new DateTime(2025, 6, 20, 18, 51, 35, 723, DateTimeKind.Local).AddTicks(6730), false, 5, 4, 4 },
                    { 5, new DateTime(2025, 6, 22, 18, 51, 35, 723, DateTimeKind.Local).AddTicks(6735), false, 6, 5, 4 } 
                });

            migrationBuilder.InsertData(
                table: "Materijali",
                columns: new[] { "MaterijalID", "DatumDodavanja", "isDeleted", "Naziv", "Putanja", "SeminarID" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 6, 4, 18, 51, 35, 725, DateTimeKind.Local).AddTicks(4164), false, "Web Development Basics Slides", "materials/web_dev_basics.pdf", 1 },
                    { 2, new DateTime(2025, 6, 9, 18, 51, 35, 725, DateTimeKind.Local).AddTicks(4214), false, "Startup Fundamentals Workbook", "materials/startup_fundamentals.docx", 2 },
                    { 3, new DateTime(2025, 6, 14, 18, 51, 35, 725, DateTimeKind.Local).AddTicks(4217), false, "Nutrition & Mental Health Research", "materials/nutrition_mental_health.pdf", 3 },
                    { 4, new DateTime(2025, 6, 19, 18, 51, 35, 725, DateTimeKind.Local).AddTicks(4219), false, "Innovative Teaching Methods Guide", "materials/teaching_methods_guide.pdf", 4 },
                    { 5, new DateTime(2025, 6, 24, 18, 51, 35, 725, DateTimeKind.Local).AddTicks(4222), false, "Communication Skills Exercises", "materials/communication_skills.zip", 5 },
                    { 6, new DateTime(2025, 6, 29, 18, 51, 35, 725, DateTimeKind.Local).AddTicks(4224), false, "Advanced JavaScript Examples", "materials/advanced_js_examples.zip", 6 },
                    { 7, new DateTime(2025, 7, 4, 18, 51, 35, 725, DateTimeKind.Local).AddTicks(4226), false, "Funding Strategies Presentation", "materials/funding_strategies.pptx", 7 },
                    { 8, new DateTime(2025, 7, 4, 18, 51, 35, 725, DateTimeKind.Local).AddTicks(4229), false, "Mindfulness Exercises", "materials/mindfulness_exercises.pdf", 8 },
                    { 9, new DateTime(2025, 7, 4, 18, 51, 35, 725, DateTimeKind.Local).AddTicks(4231), false, "Blended Learning Resources", "materials/blended_learning_resources.pdf", 9 }
                });

            migrationBuilder.InsertData(
                table: "Rezervacije",
                columns: new[] { "RezervacijaID", "DatumRezervacije", "isDeleted", "KorisnikID", "SeminarID", "StateMachine" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 5, 4, 18, 51, 35, 726, DateTimeKind.Local).AddTicks(3453), false, 3, 1, "approved" },
                    { 2, new DateTime(2025, 5, 25, 18, 51, 35, 726, DateTimeKind.Local).AddTicks(3474), false, 3, 2, "approved" },
                    { 3, new DateTime(2025, 6, 4, 18, 51, 35, 726, DateTimeKind.Local).AddTicks(3478), false, 3, 3, "rejected" },
                    { 4, new DateTime(2025, 6, 29, 18, 51, 35, 726, DateTimeKind.Local).AddTicks(3484), false, 3, 7, "pending" },
                    { 5, new DateTime(2025, 7, 1, 18, 51, 35, 726, DateTimeKind.Local).AddTicks(3487), false, 3, 8, "pending" },
                    { 6, new DateTime(2025, 7, 4, 18, 51, 35, 726, DateTimeKind.Local).AddTicks(3489), false, 3, 10, "pending" },

                    { 7, new DateTime(2025, 5, 4, 18, 51, 35, 726, DateTimeKind.Local).AddTicks(3453), false, 4, 1, "approved" },
                    { 8, new DateTime(2025, 5, 4, 18, 51, 35, 726, DateTimeKind.Local).AddTicks(3453), false, 5, 1, "rejected" },
                    { 9, new DateTime(2025, 5, 4, 18, 51, 35, 726, DateTimeKind.Local).AddTicks(3453), false, 6, 1, "rejected" },

                    { 10, new DateTime(2025, 5, 25, 18, 51, 35, 726, DateTimeKind.Local).AddTicks(3474), false, 5, 2, "approved" },
                    { 11, new DateTime(2025, 5, 25, 18, 51, 35, 726, DateTimeKind.Local).AddTicks(3474), false, 4, 2, "rejected" },

                    { 12, new DateTime(2025, 6, 4, 18, 51, 35, 726, DateTimeKind.Local).AddTicks(3478), false, 4, 3, "rejected" },
                    { 13, new DateTime(2025, 6, 4, 18, 51, 35, 726, DateTimeKind.Local).AddTicks(3478), false, 6, 3, "approved" },

                    { 14, new DateTime(2025, 6, 4, 18, 51, 35, 726, DateTimeKind.Local).AddTicks(3478), false, 5, 4, "approved" },
                    { 15, new DateTime(2025, 6, 4, 18, 51, 35, 726, DateTimeKind.Local).AddTicks(3478), false, 6, 4, "approved" },
                    { 16, new DateTime(2025, 6, 4, 18, 51, 35, 726, DateTimeKind.Local).AddTicks(3478), false, 3, 4, "rejected" },

                    { 17, new DateTime(2025, 6, 4, 18, 51, 35, 726, DateTimeKind.Local).AddTicks(3478), false, 4, 5, "pending" },
                    { 18, new DateTime(2025, 6, 4, 18, 51, 35, 726, DateTimeKind.Local).AddTicks(3478), false, 5, 5, "rejected" },
                    { 19, new DateTime(2025, 6, 4, 18, 51, 35, 726, DateTimeKind.Local).AddTicks(3478), false, 6, 5, "pending" },

                    { 20, new DateTime(2025, 6, 4, 18, 51, 35, 726, DateTimeKind.Local).AddTicks(3478), false, 4, 6, "rejected" },
                    { 21, new DateTime(2025, 6, 4, 18, 51, 35, 726, DateTimeKind.Local).AddTicks(3478), false, 5, 6, "rejected" },
                    { 22, new DateTime(2025, 6, 4, 18, 51, 35, 726, DateTimeKind.Local).AddTicks(3478), false, 6, 6, "approved" },

                    { 23, new DateTime(2025, 6, 4, 18, 51, 35, 726, DateTimeKind.Local).AddTicks(3478), false, 4, 9, "pending" },
                    { 24, new DateTime(2025, 6, 4, 18, 51, 35, 726, DateTimeKind.Local).AddTicks(3478), false, 5, 9, "pending" },
                    { 25, new DateTime(2025, 6, 4, 18, 51, 35, 726, DateTimeKind.Local).AddTicks(3478), false, 6, 9, "pending" },


                });

            migrationBuilder.InsertData(
                table: "SacuvaniSeminari",
                columns: new[] { "SacuvaniSeminarID", "DatumSacuvanja", "IsDeleted", "KorisnikID", "SeminarID" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 6, 24, 18, 51, 35, 726, DateTimeKind.Local).AddTicks(6421), false, 3, 2 },
                    { 2, new DateTime(2025, 6, 29, 18, 51, 35, 726, DateTimeKind.Local).AddTicks(6438), false, 3, 5 },
                    { 3, new DateTime(2025, 7, 4, 18, 51, 35, 726, DateTimeKind.Local).AddTicks(6440), false, 3, 8 }
                });

            migrationBuilder.InsertData(
                table: "SponzoriSeminari",
                columns: new[] { "SponzoriSeminariID", "IsDeleted", "SeminarID", "SponzorID" },
                values: new object[,]
                {
                    { 1, false, 1, 1 },
                    { 2, false, 2, 2 },
                    { 3, false, 3, 3 },
                    { 4, false, 4, 1 },
                    { 5, false, 5, 4 },
                    { 6, false, 6, 2 },
                    { 7, false, 7, 3 },
                    { 8, false, 8, 5 },
                    { 9, false, 9, 4 },
                    { 10, false, 10, 5 }
                });

            migrationBuilder.CreateIndex(
                name: "IX_Dojmovi_KorisnikID",
                table: "Dojmovi",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_Dojmovi_SeminarID",
                table: "Dojmovi",
                column: "SeminarID");

            migrationBuilder.CreateIndex(
                name: "IX_Korisnici_Uloga",
                table: "Korisnici",
                column: "Uloga");

            migrationBuilder.CreateIndex(
                name: "IX_Materijali_SeminarID",
                table: "Materijali",
                column: "SeminarID");

            migrationBuilder.CreateIndex(
                name: "IX_Obavijesti_KorisnikID",
                table: "Obavijesti",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_Rezervacije_KorisnikID",
                table: "Rezervacije",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_Rezervacije_SeminarID",
                table: "Rezervacije",
                column: "SeminarID");

            migrationBuilder.CreateIndex(
                name: "IX_SacuvaniSeminari_KorisnikID",
                table: "SacuvaniSeminari",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_SacuvaniSeminari_SeminarID",
                table: "SacuvaniSeminari",
                column: "SeminarID");

            migrationBuilder.CreateIndex(
                name: "IX_Seminari_KategorijaID",
                table: "Seminari",
                column: "KategorijaID");

            migrationBuilder.CreateIndex(
                name: "IX_Seminari_KorisnikID",
                table: "Seminari",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_Seminari_PredavacID",
                table: "Seminari",
                column: "PredavacID");

            migrationBuilder.CreateIndex(
                name: "IX_SponzoriSeminari_SeminarID",
                table: "SponzoriSeminari",
                column: "SeminarID");

            migrationBuilder.CreateIndex(
                name: "IX_SponzoriSeminari_SponzorID",
                table: "SponzoriSeminari",
                column: "SponzorID");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Dojmovi");

            migrationBuilder.DropTable(
                name: "Materijali");

            migrationBuilder.DropTable(
                name: "Obavijesti");

            migrationBuilder.DropTable(
                name: "Rezervacije");

            migrationBuilder.DropTable(
                name: "SacuvaniSeminari");

            migrationBuilder.DropTable(
                name: "SponzoriSeminari");

            migrationBuilder.DropTable(
                name: "Seminari");

            migrationBuilder.DropTable(
                name: "Sponzori");

            migrationBuilder.DropTable(
                name: "Kategorije");

            migrationBuilder.DropTable(
                name: "Korisnici");

            migrationBuilder.DropTable(
                name: "Predavaci");

            migrationBuilder.DropTable(
                name: "Uloge");
        }
    }
}
