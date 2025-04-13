using eSeminars.Model;
using eSeminars.Model.Models;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services;
using eSeminars.Services.Dojmovi;
using Microsoft.AspNetCore.Authorization;

namespace eSeminars.API.Controllers
{
    public class DojmoviController : BaseCRUDController<Model.Models.Dojmovi, DojmoviSearchObject, DojmoviInsertRequest, DojmoviUpdateRequest>
    {
        public DojmoviController(IDojmoviService service) : base(service)
        {
        }
        [Authorize(Roles = "Administrator,Korisnik,Organizator")]
        public override PagedResult<Dojmovi> GetList(DojmoviSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }
        [Authorize(Roles = "Administrator,Korisnik")]
        public override Dojmovi Insert(DojmoviInsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Administrator,Korisnik")]
        public override Dojmovi Update(int id, DojmoviUpdateRequest request)
        {
            return base.Update(id, request);
        }
        [Authorize(Roles = "Administrator,Korisnik,Organizator")]
        public override Dojmovi GetById(int id)
        {
            return base.GetById(id);
        }
    }
}
