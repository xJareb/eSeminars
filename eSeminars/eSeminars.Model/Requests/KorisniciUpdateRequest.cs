using System;
using System.Collections.Generic;
using System.Text;

namespace eSeminars.Model.Requests
{
    public class KorisniciUpdateRequest
    {
        public string Ime { get; set; }
        public string Prezime { get; set; }
        public string? Lozinka { get; set; }
        public string? LozinkaPotvrda { get; set; }
    }
}
