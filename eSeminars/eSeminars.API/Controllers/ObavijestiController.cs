using eSeminars.Model;
using eSeminars.Model.Models;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services;
using eSeminars.Services.Obavijesti;
using Microsoft.AspNetCore.Authorization;

namespace eSeminars.API.Controllers
{
    public class ObavijestiController : BaseCRUDController<Model.Models.Obavijesti, ObavijestiSearchObject, ObavijestiInsertRequest, ObavijestiUpdateRequest>
    {
        public ObavijestiController(IObavijestiService service) : base(service)
        {
        }
        [AllowAnonymous]
        public override PagedResult<Obavijesti> GetList(ObavijestiSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }

        [Authorize(Roles = "Administrator,Organizator")]
        public override Obavijesti Insert(ObavijestiInsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Administrator,Organizator")]
        public override Obavijesti Update(int id, ObavijestiUpdateRequest request)
        {
            return base.Update(id, request);
        }
        [AllowAnonymous]
        public override Obavijesti GetById(int id)
        {
            return base.GetById(id);
        }
    }
}
