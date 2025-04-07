using eSeminars.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eSeminars.Model.Requests;

namespace eSeminars.Services.SeminariStateMachine
{
    public class InitialSeminariState : BaseSeminariState
    {
        public InitialSeminariState(ESeminarsContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override Model.Models.Seminari Insert(SeminariInsertRequest request)
        {
            var set = Context.Set<Database.Seminari>();
            var entity = Mapper.Map<Database.Seminari>(request);
            entity.StateMachine = "draft";
            entity.DatumKreiranja = DateTime.Now;
            set.Add(entity);
            Context.SaveChanges();

            return Mapper.Map<Model.Models.Seminari>(entity);
        }
    }
}
