using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eSeminars.Model;
using eSeminars.Model.SearchObjects;

namespace eSeminars.Services
{
    public interface IService<TModel, Tsearch> where Tsearch : BaseSearchObject
    {
        public PagedResult<TModel> GetPaged(Tsearch search);

        public TModel GetById(int id);
    }
}
