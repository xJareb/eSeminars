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
    public class PredavaciController : BaseController<Model.Predavaci,PredavaciSearchObject>
    {

        public PredavaciController(IPredavaciService service) : base(service)
        {
           
        }
        
    }
}
