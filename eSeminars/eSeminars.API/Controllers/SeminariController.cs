using eSeminars.Model.Models;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services;
using eSeminars.Services.Seminari;
using Microsoft.AspNetCore.Mvc;

namespace eSeminars.API.Controllers
{
    public class SeminariController : BaseCRUDController<Model.Models.Seminari, SeminariSearchObject, SeminariInsertRequest, SeminariUpdateRequest>
    {
        public SeminariController(ISeminariService service) : base(service)
        {

        }
        [HttpPut("{id}/activate")]
        public Seminari Activate(int id)
        {
            return (_service as ISeminariService).Activate(id);
        }
    }
}
