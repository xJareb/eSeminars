using eSeminars.Model;
using eSeminars.Model.Models;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services;
using eSeminars.Services.SponzoriSeminari;
using Microsoft.AspNetCore.Authorization;

namespace eSeminars.API.Controllers
{
    public class SponzoriSeminariController : BaseCRUDController<Model.Models.SponzoriSeminari, SponzoriSeminariSearchObject, SponzoriSeminariInsertRequest, SponzoriSeminariUpdateRequest>
    {
        public SponzoriSeminariController(ISponzoriSeminariService service) : base(service)
        {
        }

        [AllowAnonymous]
        public override SponzoriSeminari GetById(int id)
        {
            return base.GetById(id);
        }

        [AllowAnonymous]
        public override PagedResult<SponzoriSeminari> GetList(SponzoriSeminariSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }

        [Authorize(Roles = "Administrator,Organizator")]
        public override SponzoriSeminari Insert(SponzoriSeminariInsertRequest request)
        {
            return base.Insert(request);
        }
        [Authorize(Roles = "Administrator,Organizator")]
        public override SponzoriSeminari Update(int id, SponzoriSeminariUpdateRequest request)
        {
            return base.Update(id, request);
        }
    }
}
