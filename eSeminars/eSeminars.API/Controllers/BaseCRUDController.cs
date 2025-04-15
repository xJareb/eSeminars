﻿using eSeminars.Model.SearchObjects;
using eSeminars.Services;
using Microsoft.AspNetCore.Mvc;

namespace eSeminars.API.Controllers
{
    public class BaseCRUDController<TModel, TSearch, TInsert, TUpdate> : BaseController<TModel, TSearch> where TSearch : BaseSearchObject where TModel : class
    {
        protected new ICRUDService<TModel, TSearch, TInsert, TUpdate> _service;
        public BaseCRUDController(ICRUDService<TModel, TSearch, TInsert,TUpdate> service) : base(service)
        {
            _service = service;
        }

        [HttpPost]
        public virtual TModel Insert(TInsert request)
        {
            return _service.Insert(request);
        }
        [HttpPut("{id}")]
        public virtual TModel Update(int id,TUpdate request)
        {
            return _service.Update(id,request);
        }

        [HttpPut("delete")]
        public virtual TModel Delete(int id)
        {
            return _service.Delete(id);
        }
    }
}
