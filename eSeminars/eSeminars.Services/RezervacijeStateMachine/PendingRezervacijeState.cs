using eSeminars.Model;
using eSeminars.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSeminars.Services.RezervacijeStateMachine
{
    public class PendingRezervacijeState : BaseRezervacijeState
    {
        public PendingRezervacijeState(ESeminarsContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override Model.Models.Rezervacije Allow(int id)
        {
            var set = Context.Set<Database.Rezervacije>();

            var seminarset = Context.Set<Database.Seminari>();

            var entity = set.Find(id);

            var seminarId = entity.SeminarId;

            var seminar = seminarset.Find(seminarId);

            if(seminar.Zauzeti > seminar.Kapacitet)
            {
                throw new UserException("Capacity is full");
            }else
            {
                seminar.Zauzeti = seminar.Zauzeti + 1;
            }

            entity.StateMachine = "approved";

            Context.SaveChanges();

            return Mapper.Map<Model.Models.Rezervacije>(entity);
        }

        public override Model.Models.Rezervacije Reject(int id)
        {
            var set = Context.Set<Database.Rezervacije>();

            var entity = set.Find(id);

            entity.StateMachine = "rejected";

            Context.SaveChanges();

            return Mapper.Map<Model.Models.Rezervacije>(entity);
        }

        public override List<string> AllowedActions(Database.Rezervacije entity)
        {
            return new List<string>() { nameof(Allow), nameof(Reject) };
        }
    }
}
