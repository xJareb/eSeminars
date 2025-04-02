using eSeminars.Model.Models;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services;
using eSeminars.Services.SacuvaniSeminari;

namespace eSeminars.API.Controllers
{
    public class SacuvaniSeminariController : BaseCRUDController<Model.Models.SacuvaniSeminari, SacuvaniSeminariSearchObject, SacuvaniSeminariInsertRequest, SacuvaniSeminariUpdateRequest>
    {
        public SacuvaniSeminariController(ISacuvaniSeminariService service) : base(service)
        {
        }
    }
}
