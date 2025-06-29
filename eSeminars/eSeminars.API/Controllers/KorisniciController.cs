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
        private readonly IKorisniciService _korisniciService;
        public KorisniciController(IKorisniciService service) : base(service)
        {
            _korisniciService = service;
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
        [AllowAnonymous]
        [HttpGet("{userId}/recommended-seminars")]
        public ActionResult<List<Model.Models.Seminari>> GetRecommendedDoktori(int userId)
        {
            var recommended = _korisniciService.GetRecommendedSeminars(userId);
            return Ok(recommended);
        }
        [Authorize(Roles = "Administrator,Organizator,Korisnik")]
        [HttpGet("train-model")]
        public void TrainModel()
        {
            _korisniciService.TrainModel();
        }
    }
}
