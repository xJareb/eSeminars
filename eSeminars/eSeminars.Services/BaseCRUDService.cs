﻿using eSeminars.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eSeminars.Model;
using eSeminars.Model.SearchObjects;

namespace eSeminars.Services
{
    public abstract class BaseCRUDService<TModel, TSearch, TDbEntity, TInsert, TUpdate> : BaseService<TModel, TSearch, TDbEntity> where TModel : class where TSearch : BaseSearchObject where TDbEntity : class
    {
        protected BaseCRUDService(ESeminarsContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public virtual TModel Insert(TInsert request)
        {
            TDbEntity entity = Mapper.Map<TDbEntity>(request);

            BeforeInsert(request, entity);

            Context.Add(entity);
            Context.SaveChanges();

            return Mapper.Map<TModel>(entity);
        }

        public virtual void BeforeInsert(TInsert request, TDbEntity entity) { }

        public virtual TModel Update(int id, TUpdate request)
        {
            var set = Context.Set<TDbEntity>();

            var entity = set.Find(id);

            Mapper.Map(request, entity);

            BeforeUpdate(request, entity);

            Context.SaveChanges();

            return Mapper.Map<TModel>(entity);
        }
        public virtual void BeforeUpdate(TUpdate request, TDbEntity entity) { }
        public virtual TModel Delete(int id)
        {
            var set = Context.Set<TDbEntity>();
            var entity = set.Find(id);
            if (entity == null)
            {
                throw new UserException("Record does not exist");
            }

            var property = entity.GetType().GetProperty("IsDeleted");
            if (property != null)
            {
                property.SetValue(entity, true);
            }
            else
            {
                Context.Remove(entity);
            }
            Context.SaveChanges();
            return Mapper.Map<TModel>(entity);

        }
    }
}
