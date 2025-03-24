using System;
using System.Collections.Generic;
using System.Text;

namespace eSeminars.Model.SearchObjects
{
    public class SponzoriSearchObject : BaseSearchObject
    {
        public string? KompanijaGTE { get; set; }
        public string?  Email { get; set; }
    }
}
