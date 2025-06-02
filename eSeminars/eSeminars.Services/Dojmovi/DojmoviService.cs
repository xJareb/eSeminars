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

namespace eSeminars.Services.Dojmovi
{
    public class DojmoviService : BaseCRUDService<Model.Models.Dojmovi, DojmoviSearchObject, Database.Dojmovi, DojmoviInsertRequest, DojmoviUpdateRequest>, IDojmoviService
    {
        public DojmoviService(ESeminarsContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Dojmovi> AddFilter(DojmoviSearchObject search, IQueryable<Database.Dojmovi> query)
        {
            var filteredQuery = base.AddFilter(search, query);

            filteredQuery = filteredQuery.Include(k=>k.Korisnik).Where(d => d.SeminarId == search.SeminarId);

            return filteredQuery;
        }

        public override void BeforeInsert(DojmoviInsertRequest request, Database.Dojmovi entity)
        {
            var checkDuplicates = Context.Dojmovis?
                .Where(d => d.KorisnikId == request.KorisnikId && d.SeminarId == request.SeminarId).FirstOrDefault();
            if (checkDuplicates != null)
            {
                throw new UserException("The user has already submitted feedback.");
            }
            entity.DatumKreiranjaDojma = DateTime.Now;

            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(DojmoviUpdateRequest request, Database.Dojmovi entity)
        {
            
            entity.DatumKreiranjaDojma = DateTime.Now;
            base.BeforeUpdate(request, entity);
        }
    }
}
