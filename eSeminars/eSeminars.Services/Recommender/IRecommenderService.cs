using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSeminars.Services.Recommender
{
    public interface IRecommenderService
    {
        void TrainModel();
        List<Model.Models.Seminari> GetRecommendedSeminars(int korisnikId, int numberOfRecommendation = 4);
    }
}
