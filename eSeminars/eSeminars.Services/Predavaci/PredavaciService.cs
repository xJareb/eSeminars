using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services.Database;
using MapsterMapper;
using Predavaci = eSeminars.Model.Models.Predavaci;
using System.Linq.Dynamic;
using eSeminars.Model;


namespace eSeminars.Services.Predavaci
{
    public class PredavaciService : BaseCRUDService<Model.Models.Predavaci, PredavaciSearchObject, Database.Predavaci, PredavaciInsertRequest, PredavaciUpdateRequest>, IPredavaciService
    {
        public PredavaciService(ESeminarsContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Predavaci> AddFilter(PredavaciSearchObject search, IQueryable<Database.Predavaci> query)
        {
            var filteredQuerry = base.AddFilter(search, query);

            filteredQuerry = filteredQuerry.Where(p => p.IsDeleted == false);
            if (!string.IsNullOrWhiteSpace(search?.ImePrezimeGTE))
            {
                var trimmedStart = search?.ImePrezimeGTE.TrimStart();
                filteredQuerry = filteredQuerry.Where(x =>
                    (x.Ime + ' ' + x.Prezime).ToLower().StartsWith(trimmedStart.ToLower()) ||
                    (x.Prezime + ' ' + x.Ime).ToLower().StartsWith(trimmedStart.ToLower()));
            }
            if (!string.IsNullOrWhiteSpace(search?.Email))
            {
                filteredQuerry = filteredQuerry.Where(x => x.Email == search.Email);
            }

            return filteredQuerry;
        }
        public override void BeforeInsert(PredavaciInsertRequest request, Database.Predavaci entity)
        {
            var checkDuplicates = Context.Predavacis.FirstOrDefault(p=>p.Email == request.Email);
            if (checkDuplicates != null)
            {
                throw new UserException($"Lecturer with {checkDuplicates.Email} already exist ");
            }
            base.BeforeInsert(request, entity);
        }
    }
}
