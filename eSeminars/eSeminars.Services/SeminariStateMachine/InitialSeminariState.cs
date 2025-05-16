using eSeminars.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eSeminars.Model.Requests;
using Microsoft.AspNetCore.Http;
using eSeminars.Model;
using System.Security.Claims;

namespace eSeminars.Services.SeminariStateMachine
{
    public class InitialSeminariState : BaseSeminariState
    {
        private readonly IHttpContextAccessor _httpContextAccessor;
        public InitialSeminariState(ESeminarsContext context, IMapper mapper, IServiceProvider serviceProvider, IHttpContextAccessor httpContextAccessor) : base(context, mapper, serviceProvider)
        {
            _httpContextAccessor = httpContextAccessor;
        }

        public override Model.Models.Seminari Insert(SeminariInsertRequest request)
        {
            var set = Context.Set<Database.Seminari>();
            var entity = Mapper.Map<Database.Seminari>(request);
            entity.StateMachine = "draft";
            entity.DatumKreiranja = DateTime.Now;
            var user = _httpContextAccessor.HttpContext?.User;

            var userEmail = user.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            var userDb = Context.Korisnicis.Where(k => k.Email == userEmail).FirstOrDefault();
            if (userDb == null)
            {
                throw new UserException("User not found");
            }

            var userDbId = userDb.KorisnikId;

            entity.KorisnikId = userDbId;
            set.Add(entity);
            Context.SaveChanges();

            return Mapper.Map<Model.Models.Seminari>(entity);
        }

        public override List<string> AllowedActions(Database.Seminari entity)
        {
            return new List<string>() {nameof(Insert)};
        }
    }
}
