using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eSeminars.Model;

namespace eSeminars.Services
{
    public interface IProizvodiService
    {
        List<Proizvodi> GetList();
    }
}
