using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;

namespace eSeminars.Services
{
    public interface IKategorijeService : ICRUDService<Model.Kategorije,KategorijeSearchObject,KategorijeInsertRequest,KategorijeUpdateRequest>
    {
    }
}
