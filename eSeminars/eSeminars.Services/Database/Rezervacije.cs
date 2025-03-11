using System;
using System.Collections.Generic;

namespace eSeminars.Services.Database;

public partial class Rezervacije
{
    public int RezervacijaId { get; set; }

    public int? SeminarId { get; set; }

    public int? KorisnikId { get; set; }

    public string StatusRezervacije { get; set; } = null!;

    public DateTime DatumRezervacije { get; set; }

    public virtual Korisnici? Korisnik { get; set; }

    public virtual Seminari? Seminar { get; set; }
}
