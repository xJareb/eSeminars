using eSeminars.Model;
using eSeminars.Model.Requests;
using eSeminars.Services.Database;
using MapsterMapper;
using Microsoft.Extensions.DependencyInjection;

namespace eSeminars.Services.SeminariStateMachine
{
    public class BaseSeminariState
    {
        public ESeminarsContext Context { get; set; }
        public IMapper Mapper { get; set; }
        public IServiceProvider ServiceProvider { get; set; }

        public BaseSeminariState(ESeminarsContext context, IMapper mapper, IServiceProvider serviceProvider)
        {
            Context = context;
            Mapper = mapper;
            ServiceProvider = serviceProvider;
        }
        public virtual Model.Models.Seminari Insert(SeminariInsertRequest request)
        {
            throw new UserException("Method not allowed");
        }
        public virtual Model.Models.Seminari Update(int id, SeminariUpdateRequest request)
        {
            throw new UserException("Method not allowed");
        }

        public virtual Model.Models.Seminari Activate(int id)
        {
            throw new UserException("Method not allowed");
        }
        public virtual Model.Models.Seminari Hide(int id)
        {
            throw new UserException("Method not allowed");
        }

        public virtual Model.Models.Seminari Edit(int id)
        {
            throw new UserException("Method not allowed");
        }

        public virtual List<string> AllowedActions(Database.Seminari entity)
        {
            throw new UserException("Method not allowed");
        }
        public BaseSeminariState CreateState(string stateName)
        {
            switch (stateName)
            {
                case "initial":
                    return ServiceProvider.GetService<InitialSeminariState>();
                case "draft":
                    return ServiceProvider.GetService<DraftSeminariState>();
                case "active":
                    return ServiceProvider.GetService<ActiveSeminariState>();
                case "hidden":
                    return ServiceProvider.GetService<HiddenSeminariState>();
                default: throw new Exception("State not recognized");
            }
        }
    }
}
