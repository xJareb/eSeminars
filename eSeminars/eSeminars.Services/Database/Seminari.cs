using System;
using System.Collections.Generic;

namespace eSeminars.Services.Database;

public partial class Seminari
{
    public int SeminarId { get; set; }

    public string Naslov { get; set; } = null!;

    public string Opis { get; set; } = null!;

    public DateTime DatumVrijeme { get; set; }

    public string Lokacija { get; set; } = null!;

    public int Kapacitet { get; set; }
    public int Zauzeti { get; set; } 

    public string? StateMachine { get; set; }

    public int? KorisnikId { get; set; }

    public int? PredavacId { get; set; }

    public DateTime DatumKreiranja { get; set; }

    public int? KategorijaId { get; set; }

    public bool? IsDeleted { get; set; }

    public virtual ICollection<Dojmovi> Dojmovis { get; set; } = new List<Dojmovi>();

    public virtual Kategorije? Kategorija { get; set; }

    public virtual Korisnici? Korisnik { get; set; }

    public virtual ICollection<Materijali> Materijalis { get; set; } = new List<Materijali>();

    public virtual Predavaci? Predavac { get; set; }

    public virtual ICollection<Rezervacije> Rezervacijes { get; set; } = new List<Rezervacije>();

    public virtual ICollection<SacuvaniSeminari> SacuvaniSeminaris { get; set; } = new List<SacuvaniSeminari>();

    public virtual ICollection<SponzoriSeminari> SponzoriSeminaris { get; set; } = new List<SponzoriSeminari>();
}
