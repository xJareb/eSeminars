﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eSeminars.Model;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services.Database;
using eSeminars.Services.RezervacijeStateMachine;
using eSeminars.Services.SeminariStateMachine;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace eSeminars.Services.Rezervacije
{
    public class RezervacijeService : BaseCRUDService<Model.Models.Rezervacije, RezervacijeSearchObject, Database.Rezervacije, RezervacijeInsertRequest, RezervacijeUpdateRequest>, IRezervacijeService
    {
        public BaseRezervacijeState BaseRezervacijeState { get; set; }
        public ILogger<RezervacijeService> _logger { get; set; }
        public RezervacijeService(ESeminarsContext context, IMapper mapper, BaseRezervacijeState baseRezervacijeState, ILogger<RezervacijeService> logger) : base(context, mapper)
        {
            _logger = logger;
            BaseRezervacijeState = baseRezervacijeState;
        }

        public override IQueryable<Database.Rezervacije> AddFilter(RezervacijeSearchObject search, IQueryable<Database.Rezervacije> query)
        {
            var filteredQuery = base.AddFilter(search, query);

            filteredQuery = filteredQuery.Include(r => r.Korisnik).Where(s => s.SeminarId == search.SeminarId);

            return filteredQuery;
        }

        public override void BeforeInsert(RezervacijeInsertRequest request, Database.Rezervacije entity)
        {
            var checkDuplicates = Context.Rezervacijes
                .Where(r => r.KorisnikId == request.KorisnikId && r.SeminarId == request.SeminarId).FirstOrDefault();
            if (checkDuplicates != null)
            {
                throw new UserException("Record already exists in the database");
            }

            entity.DatumRezervacije = DateTime.Now;
            //TODO :: remove attribute
            entity.StatusRezervacije = "x";
            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(RezervacijeUpdateRequest request, Database.Rezervacije entity)
        {
            entity.DatumRezervacije = DateTime.Now;
            base.BeforeUpdate(request, entity);
        }

        public override Model.Models.Rezervacije Insert(RezervacijeInsertRequest request)
        {
            var state = BaseRezervacijeState.CreateState("initial");
            return state.Insert(request);
        }

        public Model.Models.Rezervacije Allow(int id)
        {
            var entity = GetById(id);
            var state = BaseRezervacijeState.CreateState(entity.StateMachine);
            return state.Allow(id);
        }

        public Model.Models.Rezervacije Reject(int id)
        {
            var entity = GetById(id);
            var state = BaseRezervacijeState.CreateState(entity.StateMachine);
            return state.Reject(id);
        }

        public List<string> AllowedActions(int id)
        {
            _logger.LogInformation($"Allowed actions called for: {id}");
            if (id <= 0)
            {
                var state = BaseRezervacijeState.CreateState("initial");
                return state.AllowedActions(null);
            }
            else
            {
                var entity = Context.Rezervacijes.Find(id);
                var state = BaseRezervacijeState.CreateState(entity.StateMachine);
                return state.AllowedActions(entity);
            }
        }
    }
}
