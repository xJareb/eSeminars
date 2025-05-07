using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services.Database;
using MapsterMapper;

namespace eSeminars.Services.Sponzori
{
    public class SponzoriService : BaseCRUDService<Model.Models.Sponzori, SponzoriSearchObject, Database.Sponzori, SponzoriInsertRequest, SponzoriUpdateRequest>, ISponzoriService
    {
        public SponzoriService(ESeminarsContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Sponzori> AddFilter(SponzoriSearchObject search, IQueryable<Database.Sponzori> query)
        {
            var filteredQuerry = base.AddFilter(search, query);

            filteredQuerry = filteredQuerry.Where(s => s.IsDeleted == false);

            if (!string.IsNullOrWhiteSpace(search?.KompanijaGTE))
            {
                filteredQuerry = filteredQuerry.Where(s => s.Naziv.StartsWith(search.KompanijaGTE));
            }

            if (!string.IsNullOrWhiteSpace(search?.Email))
            {
                filteredQuerry = filteredQuerry.Where(s => s.Email == search.Email);
            }
            return filteredQuerry;
        }

        public override void BeforeInsert(SponzoriInsertRequest request, Database.Sponzori entity)
        {
            var checkDuplicates = Context.Sponzoris.FirstOrDefault(s => s.Email == request.Email);
            if (checkDuplicates != null)
            {
                throw new Exception($"Sponsor with ${checkDuplicates.Email} already exists");
            }
            base.BeforeInsert(request, entity);
        }
    }
}
