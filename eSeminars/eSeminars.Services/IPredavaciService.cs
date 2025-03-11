using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eSeminars.Model;
using eSeminars.Model.Requests;
using eSeminars.Services.Database;
using Predavaci = eSeminars.Model.Predavaci;

namespace eSeminars.Services
{
    public interface IPredavaciService
    {
        List<Predavaci> GetList();

        Predavaci Insert(PredavaciInsertRequest request);

        Predavaci Update(int id,PredavaciUpdateRequest request);
    }
}
