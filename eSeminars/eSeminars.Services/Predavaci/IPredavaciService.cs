using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Azure;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services.Database;
using Predavaci = eSeminars.Model.Models.Predavaci;

namespace eSeminars.Services.Predavaci
{
    public interface IPredavaciService : ICRUDService<Model.Models.Predavaci, PredavaciSearchObject, PredavaciInsertRequest, PredavaciUpdateRequest>
    {
    }
}
