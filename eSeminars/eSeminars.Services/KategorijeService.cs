using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services.Database;
using MapsterMapper;

namespace eSeminars.Services
{
    public class KategorijeService : BaseCRUDService<Model.Kategorije, KategorijeSearchObject, Database.Kategorije, KategorijeInsertRequest, KategorijeUpdateRequest>, IKategorijeService
    {
        public KategorijeService(ESeminarsContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Kategorije> AddFilter(KategorijeSearchObject search, IQueryable<Kategorije> query)
        {
            var filteredQuerry = base.AddFilter(search, query);

            if (!string.IsNullOrWhiteSpace(search?.NazivGTE))
            {
                filteredQuerry = filteredQuerry.Where(x => x.Naziv.StartsWith(search.NazivGTE));
            }

            return filteredQuerry;
        }
    }
}
