using System;
using System.Collections.Generic;
using System.Text;

namespace eSeminars.Model.Models
{
    public class Dojmovi
    {
        public int DojamId { get; set; }

        public int? SeminarId { get; set; }

        public int? KorisnikId { get; set; }
        public virtual Korisnici? Korisnik { get; set; }

        public int Ocjena { get; set; }
    }
}
