using eSeminars.Model.Models;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services;
using eSeminars.Services.Sponzori;

namespace eSeminars.API.Controllers
{
    public class SponzoriController : BaseCRUDController<Model.Models.Sponzori, SponzoriSearchObject, SponzoriInsertRequest, SponzoriUpdateRequest>
    {
        public SponzoriController(ISponzoriService service) : base(service)
        {
        }
    }
}
