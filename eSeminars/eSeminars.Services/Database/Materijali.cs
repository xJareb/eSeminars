using System;
using System.Collections.Generic;

namespace eSeminars.Services.Database;

public partial class Materijali
{
    public int MaterijalId { get; set; }

    public int? SeminarId { get; set; }

    public string Naziv { get; set; } = null!;

    public string Putanja { get; set; } = null!;

    public DateTime DatumDodavanja { get; set; }

    public bool? IsDeleted { get; set; }

    public virtual Seminari? Seminar { get; set; }
}
