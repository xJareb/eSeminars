using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace eSeminars.Services.Seminari
{
    public class SeminariService : BaseCRUDService<Model.Models.Seminari, SeminariSearchObject, Database.Seminari, SeminariInsertRequest, SeminariUpdateRequest>, ISeminariService
    {
        public SeminariService(ESeminarsContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Seminari> AddFilter(SeminariSearchObject search, IQueryable<Database.Seminari> query)
        {
            var filteredQuerry = base.AddFilter(search, query);

                filteredQuerry = filteredQuerry.Include(s => s.Korisnik)
                    .Include(s => s.Predavac)
                    .Include(s => s.Kategorija);

                if (!string.IsNullOrWhiteSpace(search?.NaslovGTE))
                {
                    filteredQuerry = filteredQuerry.Where(s => s.Naslov.StartsWith(search.NaslovGTE));
                }

                if (!string.IsNullOrWhiteSpace(search?.KategorijaLIKE))
                {
                    filteredQuerry = filteredQuerry.Where(k => k.Kategorija.Naziv == search.KategorijaLIKE);
                }
            return filteredQuerry;
        }

        public override void BeforeInsert(SeminariInsertRequest request, Database.Seminari entity)
        {
            entity.DatumKreiranja = DateTime.Now;
            //TODO:: Check role
            base.BeforeInsert(request, entity);
        }
    }
}
