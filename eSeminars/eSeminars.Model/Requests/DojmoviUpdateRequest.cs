using System;
using System.Collections.Generic;
using System.Text;

namespace eSeminars.Model.Requests
{
    public class DojmoviUpdateRequest
    {
        public int SeminarId { get; set; }
        public int KorisnikId { get; set; }
        public int Ocjena { get; set; }
    }
}
