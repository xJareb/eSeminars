using eSeminars.Model;
using eSeminars.Model.Requests;
using eSeminars.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace eSeminars.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class PredavaciController : ControllerBase
    {
        protected IPredavaciService _service;

        public PredavaciController(IPredavaciService service)
        {
            _service = service;
        }
        [HttpGet]
        public List<Predavaci> GetList()
        {
            return _service.GetList();
        }

        [HttpPost]
        public Predavaci Insert(PredavaciInsertRequest request)
        {
            return _service.Insert(request);
        }

        [HttpPut("{id}")]
        public Predavaci Update(int id,PredavaciUpdateRequest request)
        {
            return _service.Update(id, request);
        }
    }
}
