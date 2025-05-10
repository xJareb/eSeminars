using System;
using System.Collections.Generic;
using System.Text;

namespace eSeminars.Model.SearchObjects
{
    public class RezervacijeSearchObject : BaseSearchObject
    {
        public int SeminarId { get; set; }
        public string? StateMachine { get; set; }
    }
}
