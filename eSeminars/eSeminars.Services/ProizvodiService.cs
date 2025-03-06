using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eSeminars.Model;

namespace eSeminars.Services
{
    public class ProizvodiService : IProizvodiService
    {
        public List<Proizvodi> List = new List<Proizvodi>()
        {
            new Proizvodi()
            {
                ProizvodID = 1,
                Naziv = "Laptop",
                Cijena = 999
            },
            new Proizvodi()
            {
                ProizvodID = 2,
                Naziv = "Monitor",
                Cijena = 450
            },
        };
        public virtual List<Proizvodi> GetList()
        {
            return List;
        }
    }
}
