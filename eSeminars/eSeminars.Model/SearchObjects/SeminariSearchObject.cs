using System;
using System.Collections.Generic;
using System.Text;

namespace eSeminars.Model.SearchObjects
{
    public class SeminariSearchObject : BaseSearchObject
    {
        public string? NaslovGTE { get; set; }

        public string? KategorijaLIKE { get; set; }
    }
}
