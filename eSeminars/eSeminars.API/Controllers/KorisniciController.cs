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
    }
}
