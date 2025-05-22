using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using eSeminars.Model;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services.Database;
using MapsterMapper;
using Microsoft.AspNetCore.Http;

namespace eSeminars.Services.Obavijesti
{
    public class ObavijestiService : BaseCRUDService<Model.Models.Obavijesti, ObavijestiSearchObject, Database.Obavijesti, ObavijestiInsertRequest, ObavijestiUpdateRequest>, IObavijestiService
    {
        private readonly IHttpContextAccessor _httpContextAccessor;
        public ObavijestiService(ESeminarsContext context, IMapper mapper, IHttpContextAccessor httpContextAccessor) : base(context, mapper)
        {
            _httpContextAccessor = httpContextAccessor;
        }

        public override IQueryable<Database.Obavijesti> AddFilter(ObavijestiSearchObject search, IQueryable<Database.Obavijesti> query)
        {
            var filteredQuerry = base.AddFilter(search, query);

            filteredQuerry = filteredQuerry.Where(o => o.IsDeleted == false);

            if (!string.IsNullOrWhiteSpace(search?.NaslovLIKE))
            {
                filteredQuerry = filteredQuerry.Where(x => x.Naslov.ToLower().StartsWith(search.NaslovLIKE.ToLower()));
            }
            return filteredQuerry;
        }

        public override void BeforeInsert(ObavijestiInsertRequest request, Database.Obavijesti entity)
        {
            var user = _httpContextAccessor.HttpContext?.User;

            var userEmail = user.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            var userDb = Context.Korisnicis.Where(k => k.Email == userEmail).FirstOrDefault();
            if (userDb == null)
            {
                throw new UserException("User not found");
            }

            var userDbId = userDb.KorisnikId;

            entity.KorisnikId = userDbId;

            entity.DatumObavijesti = DateTime.Now;
            base.BeforeInsert(request, entity);

        }

        public override void BeforeUpdate(ObavijestiUpdateRequest request, Database.Obavijesti entity)
        {
            var user = _httpContextAccessor.HttpContext?.User;

            var userEmail = user.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            var userDb = Context.Korisnicis.Where(k => k.Email == userEmail).FirstOrDefault();
            if (userDb == null)
            {
                throw new UserException("User not found");
            }

            var userDbId = userDb.KorisnikId;

            entity.KorisnikId = userDbId;
            entity.DatumObavijesti = DateTime.Now;
            base.BeforeUpdate(request, entity);
        }
    }
}
