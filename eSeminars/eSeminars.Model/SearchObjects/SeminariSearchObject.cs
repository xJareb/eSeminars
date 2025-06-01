using System;
using System.Collections.Generic;
using System.Text;

namespace eSeminars.Model.SearchObjects
{
    public class SeminariSearchObject : BaseSearchObject
    {
        public string? NaslovGTE { get; set; }

        public string? KategorijaLIKE { get; set; }
        public bool? isActive { get; set; }

        public int? SeminarId { get; set; }
        public bool? isHistory { get; set; }
        public int? KorisnikId { get; set; }
        public bool? includeMaterials { get; set; }
        public bool? dateTime { get; set; }
        public bool? isDraft { get; set; }

    }
}
