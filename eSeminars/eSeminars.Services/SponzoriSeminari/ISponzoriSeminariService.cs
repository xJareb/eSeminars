using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;

namespace eSeminars.Services.SponzoriSeminari
{
    public interface ISponzoriSeminariService : ICRUDService<Model.Models.SponzoriSeminari,SponzoriSeminariSearchObject,SponzoriSeminariInsertRequest,SponzoriSeminariUpdateRequest>
    {
    }
}
