using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eSeminars.Model;
using eSeminars.Model.Requests;
using eSeminars.Services.Database;
using MapsterMapper;
using Predavaci = eSeminars.Model.Predavaci;

namespace eSeminars.Services
{
    public class PredavaciService : IPredavaciService
    {
        public ESeminarsContext Context { get; set; }
        public IMapper Mapper { get; set; }
        public PredavaciService(ESeminarsContext context, IMapper mapper)
        {
            Context = context;
            Mapper = mapper;
        }

        public virtual List<Model.Predavaci> GetList()
        {
            List<Model.Predavaci> result = new List<Model.Predavaci>();

            var list = Context.Predavacis.ToList();
            //list.ForEach(x => result.Add(new Model.Predavaci()
            //{
            //    PredavacId = x.PredavacId,
            //    Ime = x.Ime,
            //    Prezime = x.Prezime,
            //    Biografija = x.Biografija,
            //    Email = x.Email,
            //    Telefon = x.Telefon
            //}));

            result = Mapper.Map(list, result);

            return result;
        }

        public Predavaci Insert(PredavaciInsertRequest request)
        {
            Database.Predavaci entity = new Database.Predavaci();
            Mapper.Map(request,entity);

            Context.Add(entity);
            Context.SaveChanges();

            return Mapper.Map<Model.Predavaci>(entity);

        }

        public Predavaci Update(int id, PredavaciUpdateRequest request)
        {
            var entity = Context.Predavacis.Find(id);

            Mapper.Map(request, entity);

            Context.SaveChanges();

            return Mapper.Map<Model.Predavaci>(entity);
        }
    }
}
