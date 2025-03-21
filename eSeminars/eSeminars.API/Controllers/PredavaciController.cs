using eSeminars.Model;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace eSeminars.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class PredavaciController : BaseCRUDController<Model.Predavaci, PredavaciSearchObject, PredavaciInsertRequest,PredavaciUpdateRequest>
    {
        public PredavaciController(IPredavaciService service) : base(service)
        {
           
        }
        
    }
}
