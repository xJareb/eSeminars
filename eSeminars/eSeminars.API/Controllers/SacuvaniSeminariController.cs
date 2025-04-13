using eSeminars.Model;
using eSeminars.Model.Models;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services;
using eSeminars.Services.SacuvaniSeminari;
using Microsoft.AspNetCore.Authorization;

namespace eSeminars.API.Controllers
{
    public class SacuvaniSeminariController : BaseCRUDController<Model.Models.SacuvaniSeminari, SacuvaniSeminariSearchObject, SacuvaniSeminariInsertRequest, SacuvaniSeminariUpdateRequest>
    {
        public SacuvaniSeminariController(ISacuvaniSeminariService service) : base(service)
        {
        }
        [Authorize(Roles = "Administrator,Korisnik")]
        public override PagedResult<SacuvaniSeminari> GetList(SacuvaniSeminariSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }
        [Authorize(Roles = "Administrator,Korisnik")]
        public override SacuvaniSeminari Insert(SacuvaniSeminariInsertRequest request)
        {
            return base.Insert(request);
        }
        [Authorize(Roles = "Administrator,Korisnik")]
        public override SacuvaniSeminari Update(int id, SacuvaniSeminariUpdateRequest request)
        {
            return base.Update(id, request);
        }
        [Authorize(Roles = "Administrator,Korisnik")]
        public override SacuvaniSeminari GetById(int id)
        {
            return base.GetById(id);
        }
    }
}
