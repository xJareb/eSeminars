using System;
using System.Collections.Generic;

namespace eSeminars.Services.Database;

public partial class Korisnici
{
    public int KorisnikId { get; set; }

    public string Ime { get; set; } = null!;

    public string Prezime { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string LozinkaHash { get; set; } = null!;

    public string LozinkaSalt { get; set; } = null!;

    public int? Uloga { get; set; }

    public DateTime DatumRodjenja { get; set; }

    public bool? IsDeleted { get; set; }

    public virtual ICollection<Dojmovi> Dojmovis { get; set; } = new List<Dojmovi>();

    public virtual ICollection<Obavijesti> Obavijestis { get; set; } = new List<Obavijesti>();

    public virtual ICollection<Rezervacije> Rezervacijes { get; set; } = new List<Rezervacije>();

    public virtual ICollection<SacuvaniSeminari> SacuvaniSeminaris { get; set; } = new List<SacuvaniSeminari>();

    public virtual ICollection<Seminari> Seminaris { get; set; } = new List<Seminari>();

    public virtual Uloge? UlogaNavigation { get; set; }
}
