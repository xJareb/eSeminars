using System;
using System.Collections.Generic;
using System.Text;

namespace eSeminars.Model
{
    public class PagedResult<T>
    {
        public int? Count { get; set; }
        public IList<T> ResultList { get; set; }
    }
}
