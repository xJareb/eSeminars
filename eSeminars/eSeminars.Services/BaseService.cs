using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eSeminars.Model;
using eSeminars.Model.SearchObjects;
using eSeminars.Services.Database;
using MapsterMapper;

namespace eSeminars.Services
{
    public abstract class BaseService<TModel, Tsearch, TDbEntity> : IService<TModel, Tsearch> where Tsearch : BaseSearchObject where TDbEntity : class where TModel : class
    {
        public ESeminarsContext Context { get; set; }
        public IMapper Mapper { get; set; }
        public BaseService(ESeminarsContext context, IMapper mapper)
        {
            Context = context;
            Mapper = mapper;
        }

        public PagedResult<TModel> GetPaged(Tsearch search)
        {
            List<TModel> result = new List<TModel>();

            var query = Context.Set<TDbEntity>().AsQueryable();

            query = AddFilter(search, query);

            int count = query.Count();

            if (search?.Page.HasValue == true && search?.PageSize.HasValue == true)
            {
                query = query.Skip(search.Page.Value * search.PageSize.Value).Take(search.PageSize.Value);
            }

            var list = query.ToList();

            result = Mapper.Map(list, result);

            PagedResult<TModel> pagedResult = new PagedResult<TModel>();
            pagedResult.ResultList = result;
            pagedResult.Count = count;

            return pagedResult;
        }

        public virtual IQueryable<TDbEntity> AddFilter(Tsearch search, IQueryable<TDbEntity> query)
        {
            return query;
        }

        public TModel GetById(int id)
        {
            var entity = Context.Set<TDbEntity>().Find(id);
            if (entity != null)
            {
                return Mapper.Map<TModel>(entity);
            }
            else
            {
                return null;
            }
        }
    }
}
