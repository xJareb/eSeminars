using eSeminars.Model;
using eSeminars.Model.Models;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services;
using eSeminars.Services.Sponzori;
using Microsoft.AspNetCore.Authorization;

namespace eSeminars.API.Controllers
{
    public class SponzoriController : BaseCRUDController<Model.Models.Sponzori, SponzoriSearchObject, SponzoriInsertRequest, SponzoriUpdateRequest>
    {
        public SponzoriController(ISponzoriService service) : base(service)
        {
        }

        [Authorize(Roles = "Administrator")]
        public override Sponzori Insert(SponzoriInsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Administrator")]
        public override Sponzori Update(int id, SponzoriUpdateRequest request)
        {
            return base.Update(id, request);
        }

        [AllowAnonymous]
        public override Sponzori GetById(int id)
        {
            return base.GetById(id);
        }

        [AllowAnonymous]
        public override PagedResult<Sponzori> GetList(SponzoriSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }
    }
}
