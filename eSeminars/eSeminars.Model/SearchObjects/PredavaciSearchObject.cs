using System;
using System.Collections.Generic;
using System.Text;

namespace eSeminars.Model.SearchObjects
{
    public class PredavaciSearchObject : BaseSearchObject
    {
        public string? ImeGTE { get; set; }
        public string? PrezimeGTE { get; set; }
        public string? Email { get; set; }
        public string? OrderBy { get; set; }
    }
}
