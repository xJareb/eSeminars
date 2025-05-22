using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using Azure.Core;
using eSeminars.Model;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services.Database;
using eSeminars.Services.SeminariStateMachine;
using MapsterMapper;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace eSeminars.Services.Seminari
{
    public class SeminariService : BaseCRUDService<Model.Models.Seminari, SeminariSearchObject, Database.Seminari, SeminariInsertRequest, SeminariUpdateRequest>, ISeminariService
    {
        
        public BaseSeminariState BaseSeminariState { get; set; }
        public ILogger<SeminariService> _logger { get; set; }
        public SeminariService(ESeminarsContext context, IMapper mapper, BaseSeminariState baseSeminariState, ILogger<SeminariService> logger) : base(context, mapper)
        {
            BaseSeminariState = baseSeminariState;
            _logger = logger;
            
        }

        public override IQueryable<Database.Seminari> AddFilter(SeminariSearchObject search, IQueryable<Database.Seminari> query)
        {

            var filteredQuerry = base.AddFilter(search, query);

                filteredQuerry = filteredQuerry.Include(s => s.Korisnik)
                    .Include(s => s.Predavac)
                    .Include(s => s.Kategorija)
                    .Include(s=>s.SponzoriSeminaris).ThenInclude(s=>s.Sponzor)
                    .Include(s=>s.Dojmovis).ThenInclude(s=>s.Korisnik);

                if (!string.IsNullOrWhiteSpace(search?.NaslovGTE))
                {
                    filteredQuerry = filteredQuerry.Where(s => s.Naslov.StartsWith(search.NaslovGTE));
                }

                if (!string.IsNullOrWhiteSpace(search?.KategorijaLIKE))
                {
                    filteredQuerry = filteredQuerry.Where(k => k.Kategorija.Naziv == search.KategorijaLIKE);
                }
                if(search?.isActive == true)
                {
                filteredQuerry = filteredQuerry.Where(k => k.StateMachine == "active");
                }
            return filteredQuerry;
        }

        public override void BeforeInsert(SeminariInsertRequest request, Database.Seminari entity)
        {
           
            entity.DatumKreiranja = DateTime.Now;
            //TODO:: Check role
            base.BeforeInsert(request, entity);
        }

        public override Model.Models.Seminari Insert(SeminariInsertRequest request)
        {

            var state = BaseSeminariState.CreateState("initial");
            return state.Insert(request);
        }

        public override Model.Models.Seminari Update(int id, SeminariUpdateRequest request)
        {
            var entity = GetById(id);
            var state = BaseSeminariState.CreateState(entity.StateMachine);
            return state.Update(id, request);
        }

        public Model.Models.Seminari Activate(int id)
        {
            var entity = GetById(id);
            var state = BaseSeminariState.CreateState(entity.StateMachine);
            return state.Activate(id);
        }

        public Model.Models.Seminari Edit(int id)
        {
            var entity = GetById(id);
            var state = BaseSeminariState.CreateState(entity.StateMachine);
            return state.Edit(id);
        }

        public Model.Models.Seminari Hide(int id)
        {
            var entity = GetById(id);
            var state = BaseSeminariState.CreateState(entity.StateMachine);
            return state.Hide(id);
        }

        public List<string> AllowedActions(int id)
        {
            _logger.LogInformation($"Allowed actions called for: {id}");
            if (id <= 0)
            {
                var state = BaseSeminariState.CreateState("initial");
                return state.AllowedActions(null);
            }
            else
            {
                var entity = Context.Seminaris.Find(id);
                var state = BaseSeminariState.CreateState(entity.StateMachine);
                return state.AllowedActions(entity);
            }
        }
    }
}
