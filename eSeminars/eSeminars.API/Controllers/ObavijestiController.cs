using eSeminars.Model.Models;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services;
using eSeminars.Services.Obavijesti;

namespace eSeminars.API.Controllers
{
    public class ObavijestiController : BaseCRUDController<Model.Models.Obavijesti, ObavijestiSearchObject, ObavijestiInsertRequest, ObavijestiUpdateRequest>
    {
        public ObavijestiController(IObavijestiService service) : base(service)
        {
        }
    }
}
