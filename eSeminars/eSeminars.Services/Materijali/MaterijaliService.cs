using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services.Database;
using MapsterMapper;

namespace eSeminars.Services.Materijali
{
    public class MaterijaliService : BaseCRUDService<Model.Models.Materijali, MaterijaliSearchObject, Database.Materijali, MaterijaliInsertRequest, MaterijaliUpdateRequest>, IMaterijalService
    {
        public MaterijaliService(ESeminarsContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Materijali> AddFilter(MaterijaliSearchObject search, IQueryable<Database.Materijali> query)
        {
            var filteredQuery = base.AddFilter(search, query);

            filteredQuery = filteredQuery.Where(m => m.SeminarId == search.SeminarId && m.IsDeleted == false);

            return filteredQuery;
        }
        public override void BeforeInsert(MaterijaliInsertRequest request, Database.Materijali entity)
        {
            entity.DatumDodavanja = DateTime.Now;
            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(MaterijaliUpdateRequest request, Database.Materijali entity)
        {
            entity.DatumDodavanja = DateTime.Now;
            base.BeforeUpdate(request, entity);
        }

        
    }
}
