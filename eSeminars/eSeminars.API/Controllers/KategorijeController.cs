using eSeminars.Model;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services;

namespace eSeminars.API.Controllers
{
    public class KategorijeController : BaseCRUDController<Model.Kategorije,KategorijeSearchObject,KategorijeInsertRequest,KategorijeUpdateRequest>
    {
        public KategorijeController(IKategorijeService service) : base(service)
        {
        }
    }
}
