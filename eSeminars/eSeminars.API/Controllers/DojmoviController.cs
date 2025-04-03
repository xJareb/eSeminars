using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services;
using eSeminars.Services.Dojmovi;

namespace eSeminars.API.Controllers
{
    public class DojmoviController : BaseCRUDController<Model.Models.Dojmovi, DojmoviSearchObject, DojmoviInsertRequest, DojmoviUpdateRequest>
    {
        public DojmoviController(IDojmoviService service) : base(service)
        {
        }
    }
}
