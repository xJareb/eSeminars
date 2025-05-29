using System;
using System.Collections.Generic;
using System.Text;

namespace eSeminars.Model.Models
{
    public class Seminari
    {
        public int SeminarId { get; set; }
        public string Naslov { get; set; }
        public string Opis { get; set; }
        public DateTime DatumVrijeme { get; set; }
        public string Lokacija { get; set; }
        public int Kapacitet { get; set; }
        public string? StateMachine { get; set; }
        public virtual Korisnici? Korisnik { get; set; }
        public virtual Predavaci? Predavac { get; set; }
        public virtual Kategorije? Kategorija { get; set; }
        public virtual ICollection<Dojmovi> Dojmovis { get; set; }
        public virtual ICollection<SponzoriSeminari> SponzoriSeminaris { get; set; }
        public virtual ICollection<Materijali> Materijalis { get; set; }

    }
}
