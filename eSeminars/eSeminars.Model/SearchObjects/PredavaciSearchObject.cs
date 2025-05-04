using System;
using System.Collections.Generic;
using System.Text;

namespace eSeminars.Model.SearchObjects
{
    public class PredavaciSearchObject : BaseSearchObject
    {
        public string? ImePrezimeGTE { get; set; }
        public string? Email { get; set; }
    }
}
