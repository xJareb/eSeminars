using eSeminars.Model.Models;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services.Kategorije;

namespace eSeminars.API.Controllers
{
    public class KategorijeController : BaseCRUDController<Kategorije,KategorijeSearchObject,KategorijeInsertRequest,KategorijeUpdateRequest>
    {
        public KategorijeController(IKategorijeService service) : base(service)
        {
        }
    }
}
