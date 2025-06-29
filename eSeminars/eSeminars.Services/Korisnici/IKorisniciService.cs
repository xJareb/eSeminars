using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eSeminars.Model.Models;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;

namespace eSeminars.Services.Korisnici
{
    public interface IKorisniciService : ICRUDService<Model.Models.Korisnici, KorisniciSearchObject, KorisniciInsertRequest, KorisniciUpdateRequest>
    {
        Model.Models.Korisnici Login(string username,string password);
        public void TrainModel();
        List<Model.Models.Seminari> GetRecommendedSeminars(int userId);
    }
}
