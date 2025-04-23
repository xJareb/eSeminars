using eSeminars.Model;
using eSeminars.Model.Models;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services.Korisnici;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eSeminars.API.Controllers
{
    public class KorisniciController : BaseCRUDController<Korisnici, KorisniciSearchObject, KorisniciInsertRequest, KorisniciUpdateRequest>
    {
        public KorisniciController(IKorisniciService service) : base(service)
        {
        }
        [HttpPost("login")]
        [AllowAnonymous]
        public Model.Models.Korisnici Login(string username, string password)
        {
            return (_service as IKorisniciService).Login(username, password);
        }
        [Authorize(Roles = "Administrator")]
        public override PagedResult<Korisnici> GetList(KorisniciSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }
        [Authorize(Roles = "Administrator,Korisnik")]
        public override Korisnici Update(int id, KorisniciUpdateRequest request)
        {
            return base.Update(id, request);
        }
        [AllowAnonymous]
        public override Korisnici Insert(KorisniciInsertRequest request)
        {
            return base.Insert(request);
        }
        [AllowAnonymous]
        public override Korisnici GetById(int id)
        {
            return base.GetById(id);
        }
    }
}
