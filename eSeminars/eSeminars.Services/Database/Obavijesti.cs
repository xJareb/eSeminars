using System;
using System.Collections.Generic;

namespace eSeminars.Services.Database;

public partial class Obavijesti
{
    public int ObavijestId { get; set; }

    public string Naslov { get; set; } = null!;

    public string Sadrzaj { get; set; } = null!;

    public DateTime DatumObavijesti { get; set; }

    public int? KorisnikId { get; set; }

    public virtual Korisnici? Korisnik { get; set; }
}
