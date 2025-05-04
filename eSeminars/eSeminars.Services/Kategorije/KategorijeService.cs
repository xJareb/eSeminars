using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eSeminars.Model.Models;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services.Database;
using MapsterMapper;
using Kategorije = eSeminars.Services.Database.Kategorije;

namespace eSeminars.Services.Kategorije
{
    public class KategorijeService : BaseCRUDService<Model.Models.Kategorije, KategorijeSearchObject, Database.Kategorije, KategorijeInsertRequest, KategorijeUpdateRequest>, IKategorijeService
    {
        public KategorijeService(ESeminarsContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Kategorije> AddFilter(KategorijeSearchObject search, IQueryable<Database.Kategorije> query)
        {
            var filteredQuerry = base.AddFilter(search, query);

            filteredQuerry = filteredQuerry.Where(k => k.IsDeleted == false);

            if (!string.IsNullOrWhiteSpace(search?.NazivGTE))
            {
                filteredQuerry = filteredQuerry.Where(x => x.Naziv.StartsWith(search.NazivGTE));
            }

            return filteredQuerry;
        }
    }
}
