using System;
using System.Collections.Generic;
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

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Data Source=localhost;Initial Catalog=eSeminars;Integrated Security=True;TrustServerCertificate=True");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Dojmovi>(entity =>
        {
            entity.HasKey(e => e.DojamId).HasName("PK__Dojmovi__FDF96C504E94FC17");

            entity.ToTable("Dojmovi");

            entity.Property(e => e.DojamId).HasColumnName("DojamID");
            entity.Property(e => e.DatumKreiranjaDojma).HasColumnType("datetime");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.SeminarId).HasColumnName("SeminarID");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Dojmovis)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK__Dojmovi__Korisni__46E78A0C");

            entity.HasOne(d => d.Seminar).WithMany(p => p.Dojmovis)
                .HasForeignKey(d => d.SeminarId)
                .HasConstraintName("FK__Dojmovi__Seminar__45F365D3");
        });

        modelBuilder.Entity<Kategorije>(entity =>
        {
            entity.HasKey(e => e.KategorijaId).HasName("PK__Kategori__6C3B8FCE4050F3E6");

            entity.ToTable("Kategorije");

            entity.Property(e => e.KategorijaId).HasColumnName("KategorijaID");
            entity.Property(e => e.Naziv)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Opis)
                .HasMaxLength(255)
                .IsUnicode(false);
        });

        modelBuilder.Entity<Korisnici>(entity =>
        {
            entity.HasKey(e => e.KorisnikId).HasName("PK__Korisnic__80B06D6161CCA4E2");

            entity.ToTable("Korisnici");

            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.DatumRodjenja).HasColumnType("date");
            entity.Property(e => e.Email)
                .HasMaxLength(70)
                .IsUnicode(false);
            entity.Property(e => e.Ime)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.LozinkaHash)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.LozinkaSalt)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Prezime)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Uloga)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        modelBuilder.Entity<Materijali>(entity =>
        {
            entity.HasKey(e => e.MaterijalId).HasName("PK__Materija__FB5CCBBDB0334B95");

            entity.ToTable("Materijali");

            entity.Property(e => e.MaterijalId).HasColumnName("MaterijalID");
            entity.Property(e => e.DatumDodavanja).HasColumnType("datetime");
            entity.Property(e => e.Naziv)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Putanja)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.SeminarId).HasColumnName("SeminarID");

            entity.HasOne(d => d.Seminar).WithMany(p => p.Materijalis)
                .HasForeignKey(d => d.SeminarId)
                .HasConstraintName("FK__Materijal__Semin__5070F446");
        });

        modelBuilder.Entity<Obavijesti>(entity =>
        {
            entity.HasKey(e => e.ObavijestId).HasName("PK__Obavijes__99D330C0521346DB");

            entity.ToTable("Obavijesti");

            entity.Property(e => e.ObavijestId).HasColumnName("ObavijestID");
            entity.Property(e => e.DatumObavijesti).HasColumnType("datetime");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.Naslov)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Sadrzaj)
                .HasMaxLength(50)
                .IsUnicode(false);

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Obavijestis)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK__Obavijest__Koris__4D94879B");
        });

        modelBuilder.Entity<Predavaci>(entity =>
        {
            entity.HasKey(e => e.PredavacId).HasName("PK__Predavac__3C1813703857B5BD");

            entity.ToTable("Predavaci");

            entity.Property(e => e.PredavacId).HasColumnName("PredavacID");
            entity.Property(e => e.Biografija)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.Email)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Ime)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Prezime)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Telefon)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        modelBuilder.Entity<Rezervacije>(entity =>
        {
            entity.HasKey(e => e.RezervacijaId).HasName("PK__Rezervac__CABA44FD98F41F00");

            entity.ToTable("Rezervacije");

            entity.Property(e => e.RezervacijaId).HasColumnName("RezervacijaID");
            entity.Property(e => e.DatumRezervacije).HasColumnType("datetime");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.SeminarId).HasColumnName("SeminarID");
            entity.Property(e => e.StatusRezervacije)
                .HasMaxLength(50)
                .IsUnicode(false);

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Rezervacijes)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK__Rezervaci__Koris__4316F928");

            entity.HasOne(d => d.Seminar).WithMany(p => p.Rezervacijes)
                .HasForeignKey(d => d.SeminarId)
                .HasConstraintName("FK__Rezervaci__Semin__4222D4EF");
        });

        modelBuilder.Entity<SacuvaniSeminari>(entity =>
        {
            entity.HasKey(e => e.SacuvaniSeminarId).HasName("PK__Sacuvani__0437E3BFE63097E9");

            entity.ToTable("SacuvaniSeminari");

            entity.Property(e => e.SacuvaniSeminarId).HasColumnName("SacuvaniSeminarID");
            entity.Property(e => e.DatumSacuvanja).HasColumnType("datetime");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.SeminarId).HasColumnName("SeminarID");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.SacuvaniSeminaris)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK__SacuvaniS__Koris__49C3F6B7");

            entity.HasOne(d => d.Seminar).WithMany(p => p.SacuvaniSeminaris)
                .HasForeignKey(d => d.SeminarId)
                .HasConstraintName("FK__SacuvaniS__Semin__4AB81AF0");
        });

        modelBuilder.Entity<Seminari>(entity =>
        {
            entity.HasKey(e => e.SeminarId).HasName("PK__Seminari__66BB8935759E7F80");

            entity.ToTable("Seminari");

            entity.Property(e => e.SeminarId).HasColumnName("SeminarID");
            entity.Property(e => e.DatumKreiranja).HasColumnType("datetime");
            entity.Property(e => e.DatumVrijeme).HasColumnType("datetime");
            entity.Property(e => e.KategorijaId).HasColumnName("KategorijaID");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.Lokacija)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Naslov)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Opis)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.PredavacId).HasColumnName("PredavacID");

            entity.HasOne(d => d.Kategorija).WithMany(p => p.Seminaris)
                .HasForeignKey(d => d.KategorijaId)
                .HasConstraintName("FK__Seminari__Katego__3F466844");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Seminaris)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK__Seminari__Korisn__3D5E1FD2");

            entity.HasOne(d => d.Predavac).WithMany(p => p.Seminaris)
                .HasForeignKey(d => d.PredavacId)
                .HasConstraintName("FK__Seminari__Predav__3E52440B");
        });

        modelBuilder.Entity<Sponzori>(entity =>
        {
            entity.HasKey(e => e.SponzorId).HasName("PK__Sponzori__8161C49A0E8FD1E1");

            entity.ToTable("Sponzori");

            entity.Property(e => e.SponzorId).HasColumnName("SponzorID");
            entity.Property(e => e.Email)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.KontaktOsoba)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Naziv)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Telefon)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        modelBuilder.Entity<SponzoriSeminari>(entity =>
        {
            entity.HasKey(e => e.SponzoriSeminariId).HasName("PK__Sponzori__BF5AC321A23EB2F9");

            entity.ToTable("SponzoriSeminari");

            entity.Property(e => e.SponzoriSeminariId).HasColumnName("SponzoriSeminariID");
            entity.Property(e => e.SeminarId).HasColumnName("SeminarID");
            entity.Property(e => e.SponzorId).HasColumnName("SponzorID");

            entity.HasOne(d => d.Seminar).WithMany(p => p.SponzoriSeminaris)
                .HasForeignKey(d => d.SeminarId)
                .HasConstraintName("FK__SponzoriS__Semin__5535A963");

            entity.HasOne(d => d.Sponzor).WithMany(p => p.SponzoriSeminaris)
                .HasForeignKey(d => d.SponzorId)
                .HasConstraintName("FK__SponzoriS__Sponz__5629CD9C");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
