using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using eSeminars.Model.Models;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;
using eSeminars.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Korisnici = eSeminars.Services.Database.Korisnici;

namespace eSeminars.Services.Korisnici
{
    public class KorisniciService : BaseCRUDService<Model.Models.Korisnici, KorisniciSearchObject, Database.Korisnici, KorisniciInsertRequest, KorisniciUpdateRequest>, IKorisniciService
    {
        public ILogger<KorisniciService> _logger { get; set; }
        public KorisniciService(ESeminarsContext context, IMapper mapper,ILogger<KorisniciService> logger) : base(context, mapper)
        {
            _logger = logger;
        }

        public override IQueryable<Database.Korisnici> AddFilter(KorisniciSearchObject search, IQueryable<Database.Korisnici> query)
        {
            var filteredQuerry = base.AddFilter(search, query);

            filteredQuerry = filteredQuerry.Where(x => x.Uloga == 2);

            if (!string.IsNullOrWhiteSpace(search?.ImePrezimeGTE))
            {
                var trimmedStart = search?.ImePrezimeGTE.TrimStart();
                filteredQuerry = filteredQuerry.Where(x =>
                    (x.Ime + ' ' + x.Prezime).ToLower().StartsWith(trimmedStart.ToLower()) ||
                    (x.Prezime + ' ' + x.Ime).ToLower().StartsWith(trimmedStart.ToLower()));
            }

            return filteredQuerry;
        }

        public override void BeforeInsert(KorisniciInsertRequest request, Database.Korisnici entity)
        {
            _logger.LogInformation($"Adding user: {entity.Ime}");
            if (request.Lozinka != request.LozinkaPotvrda)
            {
                throw new Exception("Lozinka i LozinkaPotvrda moraju biti iste");
            }

            var provjeraDuplikata = Context.Korisnicis.FirstOrDefault(k => k.Email == request.Email);
            if (provjeraDuplikata != null)
            {
                throw new Exception("Korisnik sa unesenim emailom već postoji");
            }
            //TODO:: change uloga later
            entity.Uloga = 2;
            entity.LozinkaSalt = GenerateSalt();
            entity.LozinkaHash = GenerateHash(entity.LozinkaSalt, request.Lozinka);
            base.BeforeInsert(request, entity);
        }

        public static string GenerateSalt()
        {
            var byteArray = RandomNumberGenerator.GetBytes(16);

            return Convert.ToBase64String(byteArray);
        }
        public static string GenerateHash(string salt, string password)
        {
            byte[] src = Convert.FromBase64String(salt);
            byte[] bytes = Encoding.Unicode.GetBytes(password);
            byte[] dst = new byte[src.Length + bytes.Length];

            Buffer.BlockCopy(src, 0, dst, 0, src.Length);
            Buffer.BlockCopy(bytes, 0, dst, src.Length, bytes.Length);

            HashAlgorithm algorithm = HashAlgorithm.Create("SHA1");
            byte[] inArray = algorithm.ComputeHash(dst);
            return Convert.ToBase64String(inArray);
        }

        public override void BeforeUpdate(KorisniciUpdateRequest request, Database.Korisnici entity)
        {
            base.BeforeUpdate(request, entity);
            if (request.Lozinka != null)
            {
                if (request.Lozinka != request.LozinkaPotvrda)
                {
                    throw new Exception("Lozinka i LozinkaPotvrda moraju biti iste");
                }
            }
            entity.LozinkaSalt = GenerateSalt();
            entity.LozinkaHash = GenerateHash(entity.LozinkaSalt, request.Lozinka);
        }

        public Model.Models.Korisnici Login(string username, string password)
        {
            var entity = Context.Korisnicis.FirstOrDefault(x => x.Email == username);
            if (entity == null)
            {
                return null;
            }

            var hash = GenerateHash(entity.LozinkaSalt, password);

            if (hash != entity.LozinkaHash)
            {
                return null;
            }

            return Mapper.Map<Model.Models.Korisnici>(entity);
        }
    }
}
