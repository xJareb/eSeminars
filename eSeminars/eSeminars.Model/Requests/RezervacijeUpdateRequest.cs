using System;
using System.Collections.Generic;
using System.Text;

namespace eSeminars.Model.Requests
{
    public class RezervacijeUpdateRequest
    {
        public int SeminarId { get; set; }
        public int KorisnikId { get; set; }
    }
}
