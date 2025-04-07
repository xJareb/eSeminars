using eSeminars.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eSeminars.Model.Requests;
using Azure.Core;

namespace eSeminars.Services.SeminariStateMachine
{
    public class DraftSeminariState : BaseSeminariState
    {
        public DraftSeminariState(ESeminarsContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override Model.Models.Seminari Update(int id, SeminariUpdateRequest request)
        {
            var set = Context.Set<Database.Seminari>();

            var entity = set.Find(id);

            Mapper.Map(request, entity);

            Context.SaveChanges();

            return Mapper.Map<Model.Models.Seminari>(entity);
        }

        public override Model.Models.Seminari Activate(int id)
        {
            var set = Context.Set<Database.Seminari>();

            var entity = set.Find(id);

            entity.StateMachine = "active";

            Context.SaveChanges();

            return Mapper.Map<Model.Models.Seminari>(entity);
        }
    }
}
