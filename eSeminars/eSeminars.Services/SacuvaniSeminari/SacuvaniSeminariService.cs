using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Azure.Core;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace eSeminars.Services.SacuvaniSeminari
{
    public class SacuvaniSeminariService : BaseCRUDService<Model.Models.SacuvaniSeminari, SacuvaniSeminariSearchObject, Database.SacuvaniSeminari, SacuvaniSeminariInsertRequest, SacuvaniSeminariUpdateRequest>, ISacuvaniSeminariService
    {
        public SacuvaniSeminariService(ESeminarsContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.SacuvaniSeminari> AddFilter(SacuvaniSeminariSearchObject search, IQueryable<Database.SacuvaniSeminari> query)
        {
            var filteredQuery =  base.AddFilter(search, query);

            filteredQuery = filteredQuery.Include(ss => ss.Seminar).Where(s => search.KorisnikId == s.KorisnikId);

            return filteredQuery;
        }

        public override void BeforeInsert(SacuvaniSeminariInsertRequest request, Database.SacuvaniSeminari entity)
        {
           
            entity.DatumSacuvanja = DateTime.Now;
            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(SacuvaniSeminariUpdateRequest request, Database.SacuvaniSeminari entity)
        {
           
            entity.DatumSacuvanja = DateTime.Now;
            base.BeforeUpdate(request, entity);
        }
    }
}
