using System;
using System.Collections.Generic;
using System.Text;

namespace eSeminars.Model.Models
{
    public class Predavaci
    {
        public int PredavacId { get; set; }
        public string Ime { get; set; } = null!;
        public string Prezime { get; set; } = null!;
        public string Biografija { get; set; } = null!;
        public string Email { get; set; } = null!;
        public string Telefon { get; set; } = null!;
    }
}
