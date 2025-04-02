using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;

namespace eSeminars.Services.SacuvaniSeminari
{
    public interface ISacuvaniSeminariService : ICRUDService<Model.Models.SacuvaniSeminari,SacuvaniSeminariSearchObject,SacuvaniSeminariInsertRequest,SacuvaniSeminariUpdateRequest>
    {
    }
}
