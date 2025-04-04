using eSeminars.Model.Models;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services;
using eSeminars.Services.SponzoriSeminari;

namespace eSeminars.API.Controllers
{
    public class SponzoriSeminariController : BaseCRUDController<Model.Models.SponzoriSeminari, SponzoriSeminariSearchObject, SponzoriSeminariInsertRequest, SponzoriSeminariUpdateRequest>
    {
        public SponzoriSeminariController(ISponzoriSeminariService service) : base(service)
        {
        }
    }
}
