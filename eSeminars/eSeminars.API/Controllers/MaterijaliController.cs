using eSeminars.Model.Models;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services;
using eSeminars.Services.Materijali;

namespace eSeminars.API.Controllers
{
    public class MaterijaliController : BaseCRUDController<Model.Models.Materijali,MaterijaliSearchObject,MaterijaliInsertRequest,MaterijaliUpdateRequest>
    {
        public MaterijaliController(IMaterijalService service) : base(service)
        {
        }
    }
}
