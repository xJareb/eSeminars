using System;
using System.Collections.Generic;
using System.Text;

namespace eSeminars.Model.Models
{
    public class Obavijesti
    {
        public int ObavijestId { get; set; }
        public string Naslov { get; set; }
        public string Sadrzaj { get; set; }
        public DateTime DatumObavijesti { get; set; }
    }
}
