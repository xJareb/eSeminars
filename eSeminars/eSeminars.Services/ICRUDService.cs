using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eSeminars.Model.SearchObjects;

namespace eSeminars.Services
{
    public interface ICRUDService<TModel,Tsearch, TInsert, TUpdate> : IService<TModel,Tsearch> where TModel : class where Tsearch : BaseSearchObject
    {
        TModel Insert(TInsert request);
        TModel Update(int id , TUpdate request);
    }
}
