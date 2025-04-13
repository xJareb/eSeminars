using eSeminars.Model;
using eSeminars.Model.Models;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services;
using eSeminars.Services.Materijali;
using Microsoft.AspNetCore.Authorization;

namespace eSeminars.API.Controllers
{
    public class MaterijaliController : BaseCRUDController<Model.Models.Materijali,MaterijaliSearchObject,MaterijaliInsertRequest,MaterijaliUpdateRequest>
    {
        public MaterijaliController(IMaterijalService service) : base(service)
        {
        }
        [AllowAnonymous]
        public override PagedResult<Materijali> GetList(MaterijaliSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }
        [Authorize(Roles = "Administrator,Organizator")]
        public override Materijali Insert(MaterijaliInsertRequest request)
        {
            return base.Insert(request);
        }
        [Authorize(Roles = "Administrator,Organizator")]
        public override Materijali Update(int id, MaterijaliUpdateRequest request)
        {
            return base.Update(id, request);
        }

        [AllowAnonymous]
        public override Materijali GetById(int id)
        {
            return base.GetById(id);
        }
    }
}
