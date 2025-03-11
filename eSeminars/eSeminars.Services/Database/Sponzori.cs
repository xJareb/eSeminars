using System;
using System.Collections.Generic;

namespace eSeminars.Services.Database;

public partial class Sponzori
{
    public int SponzorId { get; set; }

    public string Naziv { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string Telefon { get; set; } = null!;

    public string KontaktOsoba { get; set; } = null!;

    public virtual ICollection<SponzoriSeminari> SponzoriSeminaris { get; set; } = new List<SponzoriSeminari>();
}
