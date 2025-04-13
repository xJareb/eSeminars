using eSeminars.Model;
using eSeminars.Model.Models;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services;
using eSeminars.Services.Seminari;
using Microsoft.AspNetCore.Authorization;
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
        [HttpPut("{id}/edit")]
        public Seminari Edit(int id)
        {
            return (_service as ISeminariService).Edit(id);
        }
        [HttpPut("{id}/hide")]
        public Seminari Hide(int id)
        {
            return (_service as ISeminariService).Hide(id);
        }
        [HttpGet("{id}/allowedActions")]
        public List<string> AllowedActions(int id)
        {
            return (_service as ISeminariService).AllowedActions(id);
        }

        [AllowAnonymous]
        public override PagedResult<Seminari> GetList(SeminariSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }

        [AllowAnonymous]
        public override Seminari GetById(int id)
        {
            return base.GetById(id);
        }

        [Authorize(Roles = "Administrator,Organizator")]
        public override Seminari Insert(SeminariInsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Administrator,Organizator")]
        public override Seminari Update(int id, SeminariUpdateRequest request)
        {
            return base.Update(id, request);
        }
    }
}
