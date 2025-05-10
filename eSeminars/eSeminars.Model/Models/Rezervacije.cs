using System;
using System.Collections.Generic;
using System.Text;

namespace eSeminars.Model.Models
{
    public class Rezervacije
    {
        public int RezervacijaId { get; set; }
        public int SeminarId { get; set; }
        public int KorisnikId { get; set; }
        public virtual Korisnici? Korisnik { get; set; }
        public string? StateMachine { get; set; }
        public DateTime DatumRezervacije { get; set; }
    }
}
