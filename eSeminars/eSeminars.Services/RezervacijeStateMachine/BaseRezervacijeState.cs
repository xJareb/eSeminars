using eSeminars.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eSeminars.Model;
using eSeminars.Model.Requests;
using Microsoft.Extensions.DependencyInjection;

namespace eSeminars.Services.RezervacijeStateMachine
{
    public class BaseRezervacijeState
    {
        public ESeminarsContext Context { get; set; }
        public IMapper Mapper { get; set; }
        public IServiceProvider ServiceProvider { get; set; }

        public BaseRezervacijeState(ESeminarsContext context, IMapper mapper, IServiceProvider serviceProvider)
        {
            Context = context;
            Mapper = mapper;
            ServiceProvider = serviceProvider;
        }
        public virtual Model.Models.Rezervacije Insert(RezervacijeInsertRequest request)
        {
            throw new UserException("Method not allowed");
        }
        public virtual Model.Models.Rezervacije Allow(int id)
        {
            throw new UserException("Method not allowed");
        }
        public virtual Model.Models.Rezervacije Reject(int id)
        {
            throw new UserException("Method not allowed");
        }
        public virtual List<string> AllowedActions(Database.Rezervacije entity)
        {
            throw new UserException("Method not allowed");
        }
        public BaseRezervacijeState CreateState(string stateName)
        {
            switch (stateName)
            {
                case "initial":
                    return ServiceProvider.GetService<InitialRezervacijeState>();
                case "pending":
                    return ServiceProvider.GetService<PendingRezervacijeState>();
                case "approved":
                    return ServiceProvider.GetService<ApprovedRezervacijeState>();
                case "rejected":
                    return ServiceProvider.GetService<RejectedRezervacijeState>();
                default: throw new Exception("State not recognized");
            }
        }
    }
}
