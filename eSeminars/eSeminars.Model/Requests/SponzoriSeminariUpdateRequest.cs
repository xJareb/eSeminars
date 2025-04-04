using System;
using System.Collections.Generic;
using System.Text;

namespace eSeminars.Model.Requests
{
    public class SponzoriSeminariUpdateRequest
    {
        public int SeminarId { get; set; }
        public int SponzorId { get; set; }
    }
}
