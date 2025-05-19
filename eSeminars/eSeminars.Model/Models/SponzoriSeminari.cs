using System;
using System.Collections.Generic;
using System.Text;

namespace eSeminars.Model.Models
{
    public class SponzoriSeminari
    {
        public int SponzoriSeminariId { get; set; }
        public int? SeminarId { get; set; }
        public int? SponzorId { get; set; }
        public virtual Sponzori? Sponzor { get; set; }
    }
}
