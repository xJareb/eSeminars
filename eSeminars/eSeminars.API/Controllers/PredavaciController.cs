using eSeminars.Model;
using eSeminars.Model.Models;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services.Predavaci;
using Microsoft.AspNetCore.Authorization;
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
        [AllowAnonymous]
        public override PagedResult<Predavaci> GetList(PredavaciSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }
        [Authorize(Roles = "Administrator")]
        public override Predavaci Insert(PredavaciInsertRequest request)
        {
            return base.Insert(request);
        }
        [Authorize(Roles = "Administrator")]
        public override Predavaci Update(int id, PredavaciUpdateRequest request)
        {
            return base.Update(id, request);
        }
        [AllowAnonymous]
        public override Predavaci GetById(int id)
        {
            return base.GetById(id);
        }
    }
}
