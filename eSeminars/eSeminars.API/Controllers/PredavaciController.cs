using eSeminars.Model.Models;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services.Predavaci;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace eSeminars.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class PredavaciController : BaseCRUDController<Predavaci, PredavaciSearchObject, PredavaciInsertRequest, PredavaciUpdateRequest>
    {
        public PredavaciController(IPredavaciService service) : base(service)
        {

        }

    }
}
