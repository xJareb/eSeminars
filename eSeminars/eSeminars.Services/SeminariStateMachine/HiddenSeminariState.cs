using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eSeminars.Services.Database;
using MapsterMapper;

namespace eSeminars.Services.SeminariStateMachine
{
    public class HiddenSeminariState : BaseSeminariState
    {
        public HiddenSeminariState(ESeminarsContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override Model.Models.Seminari Edit(int id)
        {
            var set = Context.Set<Database.Seminari>();

            var entity = set.Find(id);

            entity.StateMachine = "draft";

            Context.SaveChanges();

            return Mapper.Map<Model.Models.Seminari>(entity);
        }

        public override List<string> AllowedActions(Database.Seminari entity)
        {
            return new List<string>() { nameof(Edit) };
        }
    }
}
