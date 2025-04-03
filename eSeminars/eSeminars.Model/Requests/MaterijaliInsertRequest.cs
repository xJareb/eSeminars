using System;
using System.Collections.Generic;
using System.Text;

namespace eSeminars.Model.Requests
{
    public class MaterijaliInsertRequest
    {
        public int SeminarId { get; set; }
        public string Naziv { get; set; }
        public string Putanja { get; set; }
    }
}
