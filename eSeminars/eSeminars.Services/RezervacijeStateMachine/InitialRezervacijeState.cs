using eSeminars.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eSeminars.Model.Requests;

namespace eSeminars.Services.RezervacijeStateMachine
{
    public class InitialRezervacijeState : BaseRezervacijeState
    {
        public InitialRezervacijeState(ESeminarsContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override Model.Models.Rezervacije Insert(RezervacijeInsertRequest request)
        {
            var set = Context.Set<Database.Rezervacije>();
            var entity = Mapper.Map<Database.Rezervacije>(request);
            entity.StateMachine = "pending";
            entity.DatumRezervacije = DateTime.Now;
            set.Add(entity);
            Context.SaveChanges();

            return Mapper.Map<Model.Models.Rezervacije>(entity);
        }

        public override List<string> AllowedActions(Database.Rezervacije entity)
        {
            return new List<string>() { nameof(Insert) };
        }
    }
}
