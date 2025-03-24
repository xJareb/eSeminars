using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eSeminars.Model.Models;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;

namespace eSeminars.Services.Kategorije
{
    public interface IKategorijeService : ICRUDService<Model.Models.Kategorije, KategorijeSearchObject, KategorijeInsertRequest, KategorijeUpdateRequest>
    {
    }
}
