using System;
using System.Collections.Generic;
using System.Text;

namespace eSeminars.Model.Requests
{
    public class ObavijestiUpdateRequest
    {
        public string Naslov { get; set; }
        public string Sadrzaj { get; set; }
        public int? KorisnikId { get; set; }
    }
}
