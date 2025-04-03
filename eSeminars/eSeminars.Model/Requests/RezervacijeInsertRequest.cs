using System;
using System.Collections.Generic;
using System.Text;

namespace eSeminars.Model.Requests
{
    public class RezervacijeInsertRequest
    {
        public int SeminarId { get; set; }
        public int KorisnikId { get; set; }
    }
}
