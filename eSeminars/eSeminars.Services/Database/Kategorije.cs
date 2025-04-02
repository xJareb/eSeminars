using System;
using System.Collections.Generic;

namespace eSeminars.Services.Database;

public partial class Kategorije
{
    public int KategorijaId { get; set; }

    public string Naziv { get; set; } = null!;

    public string Opis { get; set; } = null!;

    public bool? IsDeleted { get; set; }

    public virtual ICollection<Seminari> Seminaris { get; set; } = new List<Seminari>();
}
