using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eSeminars.Model;

namespace eSeminars.Services
{
    public class DummyProizvodiService : ProizvodiService
    {
        private DateTime time = DateTime.Now;
        public new List<Proizvodi> List = new List<Proizvodi>()
        {
            new Proizvodi()
            {
                ProizvodID = 1,
                Naziv = "Laptop",
                Cijena = 999
            }
        };
        public override List<Proizvodi> GetList()
        {
            var t = time;
            return List;
        }
    }
}
