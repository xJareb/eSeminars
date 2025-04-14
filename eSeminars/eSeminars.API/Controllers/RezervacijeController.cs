using eSeminars.Model;
using eSeminars.Model.Models;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services;
using eSeminars.Services.Rezervacije;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eSeminars.API.Controllers
{
    public class RezervacijeController : BaseCRUDController<Model.Models.Rezervacije, RezervacijeSearchObject, RezervacijeInsertRequest, RezervacijeUpdateRequest>
    {
        public RezervacijeController(IRezervacijeService service) : base(service)
        {
        }

        [Authorize(Roles = "Administrator,Organizator")]
        public override PagedResult<Rezervacije> GetList(RezervacijeSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }

        [Authorize(Roles = "Administrator,Organizator")]
        public override Rezervacije GetById(int id)
        {
            return base.GetById(id);
        }

        [Authorize(Roles = "Administrator,Korisnik")]
        public override Rezervacije Insert(RezervacijeInsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Administrator,Korisnik")]
        public override Rezervacije Update(int id, RezervacijeUpdateRequest request)
        {
            return base.Update(id, request);
        }
        [HttpPut("{id}/allow")]
        public Rezervacije Allow(int id)
        {
            return (_service as IRezervacijeService).Allow(id);
        }
        [HttpPut("{id}/reject")]
        public Rezervacije Reject(int id)
        {
            return (_service as IRezervacijeService).Reject(id);
        }
        [HttpGet("{id}/allowedActions")]
        public List<string> AllowedActions(int id)
        {
            return (_service as IRezervacijeService).AllowedActions(id);
        }
    }
}
