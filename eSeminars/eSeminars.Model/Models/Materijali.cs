using System;
using System.Collections.Generic;
using System.Text;

namespace eSeminars.Model.Models
{
    public class Materijali
    {
        public int MaterijalId { get; set; }
        public int SeminarId { get; set; }
        public string Naziv { get; set; }
        public string Putanja { get; set; }
    }
}
