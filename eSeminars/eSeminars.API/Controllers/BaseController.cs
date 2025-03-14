using eSeminars.Model;
using eSeminars.Model.SearchObjects;
using eSeminars.Services;
using Microsoft.AspNetCore.Mvc;

namespace eSeminars.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class BaseController<TModel,Tsearch> : ControllerBase where Tsearch : BaseSearchObject
    {
        protected IService<TModel,Tsearch> _service;

        public BaseController(IService<TModel, Tsearch> service)
        {
            _service = service;
        }

        [HttpGet]
        public PagedResult<TModel> GetList([FromQuery] Tsearch searchObject)
        {
            return _service.GetPaged(searchObject);
        }

        [HttpGet("{id}")]
        public TModel GetById(int id)
        {
            return _service.GetById(id);
        }
    }
}
