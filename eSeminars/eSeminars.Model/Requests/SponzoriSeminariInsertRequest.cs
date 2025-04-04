using System;
using System.Collections.Generic;
using System.Text;

namespace eSeminars.Model.Requests
{
    public class SponzoriSeminariInsertRequest
    {
        public int SeminarId { get; set; }
        public int SponzorId { get; set; }
    }
}
