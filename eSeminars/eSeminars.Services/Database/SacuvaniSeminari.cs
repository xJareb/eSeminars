using System;
using System.Collections.Generic;

namespace eSeminars.Services.Database;

public partial class SacuvaniSeminari
{
    public int SacuvaniSeminarId { get; set; }

    public int? KorisnikId { get; set; }

    public int? SeminarId { get; set; }

    public DateTime DatumSacuvanja { get; set; }

    public virtual Korisnici? Korisnik { get; set; }

    public virtual Seminari? Seminar { get; set; }
}
