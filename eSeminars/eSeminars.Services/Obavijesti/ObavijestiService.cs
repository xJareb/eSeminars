using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eSeminars.Model;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services.Database;
using MapsterMapper;

namespace eSeminars.Services.Obavijesti
{
    public class ObavijestiService : BaseCRUDService<Model.Models.Obavijesti, ObavijestiSearchObject, Database.Obavijesti, ObavijestiInsertRequest, ObavijestiUpdateRequest>, IObavijestiService
    {
        public ObavijestiService(ESeminarsContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Obavijesti> AddFilter(ObavijestiSearchObject search, IQueryable<Database.Obavijesti> query)
        {
            var filteredQuerry = base.AddFilter(search, query);

            if (!string.IsNullOrWhiteSpace(search?.NaslovLIKE))
            {
                filteredQuerry = filteredQuerry.Where(x => x.Naslov.Contains(search.NaslovLIKE));
            }
            return filteredQuerry;
        }

        public override void BeforeInsert(ObavijestiInsertRequest request, Database.Obavijesti entity)
        {
            var provjeraKorisnika = Context.Korisnicis.FirstOrDefault(k => k.KorisnikId == request.KorisnikId);
            if (provjeraKorisnika == null)
            {
                throw new UserException("User with " + request.KorisnikId + " not found");
            }

            entity.DatumObavijesti = DateTime.Now;
            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(ObavijestiUpdateRequest request, Database.Obavijesti entity)
        {
            var provjeraKorisnika = Context.Korisnicis.FirstOrDefault(k => k.KorisnikId == request.KorisnikId);
            if (provjeraKorisnika == null)
            {
                throw new UserException("User with " + request.KorisnikId + " not found");
            }
            entity.DatumObavijesti = DateTime.Now;
            base.BeforeUpdate(request, entity);
        }
    }
}
