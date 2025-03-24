using System;
using System.Collections.Generic;
using System.Text;

namespace eSeminars.Model.Requests
{
    public class SponzoriUpdateRequest
    {
        public string Naziv { get; set; }
        public string Email { get; set; }
        public string Telefon { get; set; }
        public string KontaktOsoba { get; set; }
    }
}
