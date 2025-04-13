using System;
using System.Collections.Generic;
using System.Text;

namespace eSeminars.Model.Models
{
    public class Korisnici
    {
        public int KorisnikId { get; set; }
        public string Ime { get; set; }
        public string Prezime { get; set; }
        public string Email { get; set; }
        public DateTime DatumRodjenja { get; set; }
        public Uloge UlogaNavigation { get; set; }
    }
}
