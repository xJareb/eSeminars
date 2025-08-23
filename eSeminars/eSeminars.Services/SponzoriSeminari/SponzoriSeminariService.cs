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

namespace eSeminars.Services.SponzoriSeminari
{
    public class SponzoriSeminariService : BaseCRUDService<Model.Models.SponzoriSeminari, SponzoriSeminariSearchObject, Database.SponzoriSeminari, SponzoriSeminariInsertRequest, SponzoriSeminariUpdateRequest>, ISponzoriSeminariService
    {
        public SponzoriSeminariService(ESeminarsContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.SponzoriSeminari> AddFilter(SponzoriSeminariSearchObject search, IQueryable<Database.SponzoriSeminari> query)
        {
            var filteredQuery =  base.AddFilter(search, query);

            filteredQuery = filteredQuery.Include(sp => sp.Sponzor);

            if(search.seminarId != null)
            {
                filteredQuery = filteredQuery.Where(sp => search.seminarId == sp.SeminarId && sp.IsDeleted == false);
            }

            return filteredQuery;
        }

        public override void BeforeInsert(SponzoriSeminariInsertRequest request, Database.SponzoriSeminari entity)
        {
            var checkDuplicates = Context.SponzoriSeminaris
                .Where(ss => ss.SponzorId == request.SponzorId && ss.SeminarId == request.SeminarId && ss.IsDeleted == false).FirstOrDefault();
            if (checkDuplicates != null)
            {
                throw new UserException("Sponsor already exists in seminar.");
            }

            base.BeforeInsert(request, entity);
        }
    }
}
