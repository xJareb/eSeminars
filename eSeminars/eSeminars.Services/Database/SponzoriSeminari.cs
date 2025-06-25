using System;
using System.Collections.Generic;

namespace eSeminars.Services.Database;

public partial class SponzoriSeminari
{
    public int SponzoriSeminariId { get; set; }

    public int? SeminarId { get; set; }

    public int? SponzorId { get; set; }
    public bool? IsDeleted { get; set; } = false;

    public virtual Seminari? Seminar { get; set; }

    public virtual Sponzori? Sponzor { get; set; }
}
