using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Azure;
using eSeminars.Model;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services.Database;
using Predavaci = eSeminars.Model.Predavaci;

namespace eSeminars.Services
{
    public interface IPredavaciService : ICRUDService<Predavaci, PredavaciSearchObject, PredavaciInsertRequest, PredavaciUpdateRequest>
    {
    }
}
