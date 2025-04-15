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

            if (!string.IsNullOrWhiteSpace(search?.ImeGTE))
            {
                filteredQuerry = filteredQuerry.Where(x => x.Ime.StartsWith(search.ImeGTE));
            }
            if (!string.IsNullOrWhiteSpace(search?.PrezimeGTE))
            {
                filteredQuerry = filteredQuerry.Where(x => x.Prezime.StartsWith(search.PrezimeGTE));
            }
            if (!string.IsNullOrWhiteSpace(search?.Email))
            {
                filteredQuerry = filteredQuerry.Where(x => x.Email == search.Email);
            }

            return filteredQuerry;
        }
    }
}
