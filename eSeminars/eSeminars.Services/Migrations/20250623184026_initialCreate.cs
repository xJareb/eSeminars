using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eSeminars.Services.Migrations
{
    /// <inheritdoc />
    public partial class initialCreate : Migration
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
                    Naziv = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
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
                    Biografija = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 200, nullable: false),
                    Email = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
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
                    Naziv = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    Email = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    Telefon = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    KontaktOsoba = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
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
                    Naslov = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    Sadrzaj = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
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
                    Naslov = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    Opis = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 200, nullable: false),
                    DatumVrijeme = table.Column<DateTime>(type: "datetime", nullable: false),
                    Lokacija = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
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
                    Naziv = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    Putanja = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
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
