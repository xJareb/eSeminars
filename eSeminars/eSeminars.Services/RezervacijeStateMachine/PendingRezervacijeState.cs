using EasyNetQ;
using eSeminars.Model;
using eSeminars.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EasyNetQ;
using EasyNetQ.Serialization.NewtonsoftJson;
using EasyNetQ.DI;
using eSeminars.Model.Message;
using eSeminars.Services.RabbitMQ;

namespace eSeminars.Services.RezervacijeStateMachine
{
    public class PendingRezervacijeState : BaseRezervacijeState
    {
        private readonly IRabbitMQService _rabbitMQService;
        public PendingRezervacijeState(ESeminarsContext context, IMapper mapper, IServiceProvider serviceProvider, IRabbitMQService rabbitMQService) : base(context, mapper, serviceProvider)
        {
            _rabbitMQService = rabbitMQService;
        }

        public override Model.Models.Rezervacije Allow(int id)
        {
            var set = Context.Set<Database.Rezervacije>();

            var seminarset = Context.Set<Database.Seminari>();

            var users = Context.Set<Database.Korisnici>();

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

            var user = users.Find(entity.KorisnikId);

            entity.StateMachine = "approved";

            _rabbitMQService.SendEmail(new Model.Message.Email
            {
                EmailTo = user.Email,
                Subject = "Your reservation has been approved.",
                Message = $"Dear, We are pleased to inform you that your reservation for the seminar {seminar.Naslov} has been successfully approved.",
                ReceiverName = user.Ime + " " + user.Prezime
            });

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
