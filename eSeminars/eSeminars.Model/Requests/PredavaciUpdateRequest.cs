using System;
using System.Collections.Generic;
using System.Text;

namespace eSeminars.Model.Requests
{
    public class PredavaciUpdateRequest
    {
        public string Ime { get; set; } = null!;
        public string Prezime { get; set; } = null!;
        public string Biografija { get; set; } = null!;
    }
}
