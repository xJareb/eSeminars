using System;
using System.Collections.Generic;
using System.Text;

namespace eSeminars.Model.Models
{
    public class SacuvaniSeminari
    {
        public int SacuvaniSeminarId { get; set; }
        public int? KorisnikId { get; set; }
        public virtual Seminari? Seminar { get; set; }
    }
}
