using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;

namespace eSeminars.Services.Dojmovi
{
    public interface IDojmoviService : ICRUDService<Model.Models.Dojmovi,DojmoviSearchObject,DojmoviInsertRequest,DojmoviUpdateRequest>
    {
    }
}
