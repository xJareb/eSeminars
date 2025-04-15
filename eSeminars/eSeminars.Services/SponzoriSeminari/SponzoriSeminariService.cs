using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services.Database;
using MapsterMapper;

namespace eSeminars.Services.SponzoriSeminari
{
    public class SponzoriSeminariService : BaseCRUDService<Model.Models.SponzoriSeminari, SponzoriSeminariSearchObject, Database.SponzoriSeminari, SponzoriSeminariInsertRequest, SponzoriSeminariUpdateRequest>, ISponzoriSeminariService
    {
        public SponzoriSeminariService(ESeminarsContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override void BeforeInsert(SponzoriSeminariInsertRequest request, Database.SponzoriSeminari entity)
        {
            var checkDuplicates = Context.SponzoriSeminaris
                .Where(ss => ss.SponzorId == request.SponzorId && ss.SeminarId == request.SeminarId).FirstOrDefault();
            if (checkDuplicates != null)
            {
                throw new Exception("Record already exists in the database");
            }

            base.BeforeInsert(request, entity);
        }
    }
}
