using eSeminars.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSeminars.Services.RezervacijeStateMachine
{
    public class ApprovedRezervacijeState : BaseRezervacijeState
    {
        public ApprovedRezervacijeState(ESeminarsContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override List<string> AllowedActions(Database.Rezervacije entity)
        {
            return new List<string>() { };
        }
    }
}
