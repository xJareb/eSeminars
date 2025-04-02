using System;
using System.Collections.Generic;
using System.Text;

namespace eSeminars.Model.Requests
{
    public class SeminariInsertRequest
    {
        public string Naslov { get; set; }
        public string Opis { get; set; }
        public DateTime DatumVrijeme { get; set; }
        public string Lokacija { get; set; }
        public int Kapacitet { get; set; }
        public int KorisnikId { get; set; }
        public int PredavacId { get; set; }
        public int KategorijaId { get; set; }
    }
}
