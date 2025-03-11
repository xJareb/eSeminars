using System;
using System.Collections.Generic;

namespace eSeminars.Services.Database;

public partial class Dojmovi
{
    public int DojamId { get; set; }

    public int? SeminarId { get; set; }

    public int? KorisnikId { get; set; }

    public int Ocjena { get; set; }

    public DateTime DatumKreiranjaDojma { get; set; }

    public virtual Korisnici? Korisnik { get; set; }

    public virtual Seminari? Seminar { get; set; }
}
