using eSeminars.Model;
using eSeminars.Model.Models;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services.Kategorije;
using Microsoft.AspNetCore.Authorization;

namespace eSeminars.API.Controllers
{
    public class KategorijeController : BaseCRUDController<Kategorije,KategorijeSearchObject,KategorijeInsertRequest,KategorijeUpdateRequest>
    {
        public KategorijeController(IKategorijeService service) : base(service)
        {
        }
        [Authorize(Roles = "Administrator")]
        public override Kategorije Insert(KategorijeInsertRequest request)
        {
            return base.Insert(request);
        }

        [AllowAnonymous]
        public override PagedResult<Kategorije> GetList(KategorijeSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }
    }
}
