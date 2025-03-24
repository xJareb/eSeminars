using eSeminars.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eSeminars.Model.Requests;

namespace eSeminars.Services.Obavijesti
{
    public interface IObavijestiService : ICRUDService<Model.Models.Obavijesti, ObavijestiSearchObject,ObavijestiInsertRequest,ObavijestiUpdateRequest>
    {
    }
}
