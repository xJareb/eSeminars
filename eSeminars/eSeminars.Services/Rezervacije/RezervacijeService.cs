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
using Microsoft.EntityFrameworkCore;

namespace eSeminars.Services.Rezervacije
{
    public class RezervacijeService : BaseCRUDService<Model.Models.Rezervacije, RezervacijeSearchObject, Database.Rezervacije, RezervacijeInsertRequest, RezervacijeUpdateRequest>, IRezervacijeService
    {
        public RezervacijeService(ESeminarsContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Rezervacije> AddFilter(RezervacijeSearchObject search, IQueryable<Database.Rezervacije> query)
        {
            var filteredQuery = base.AddFilter(search, query);

            filteredQuery = filteredQuery.Include(r => r.Korisnik).Where(s => s.SeminarId == search.SeminarId);

            return filteredQuery;
        }

        public override void BeforeInsert(RezervacijeInsertRequest request, Database.Rezervacije entity)
        {
            var checkDuplicates = Context.Rezervacijes
                .Where(r => r.KorisnikId == request.KorisnikId && r.SeminarId == request.SeminarId).FirstOrDefault();
            if (checkDuplicates != null)
            {
                throw new Exception("Zapis postoji u bazi");
            }

            entity.DatumRezervacije = DateTime.Now;
            //TODO :: remove attribute
            entity.StatusRezervacije = "x";
            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(RezervacijeUpdateRequest request, Database.Rezervacije entity)
        {
            entity.DatumRezervacije = DateTime.Now;
            base.BeforeUpdate(request, entity);
        }
    }
}
