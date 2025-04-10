﻿using eSeminars.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSeminars.Services.SeminariStateMachine
{
    public class ActiveSeminariState : BaseSeminariState
    {
        public ActiveSeminariState(ESeminarsContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override Model.Models.Seminari Hide(int id)
        {
            var set = Context.Set<Database.Seminari>();

            var entity = set.Find(id);

            entity.StateMachine = "hidden";

            Context.SaveChanges();

            return Mapper.Map<Model.Models.Seminari>(entity);
        }

        public override List<string> AllowedActions(Database.Seminari entity)
        {
            return new List<string>() { nameof(Hide) };
        }
    }
}
