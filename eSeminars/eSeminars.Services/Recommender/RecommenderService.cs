using eSeminars.Model.Models;
using eSeminars.Services.Database;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using Microsoft.ML.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSeminars.Services.Recommender
{
    public class RecommenderService : IRecommenderService
    {
        private static MLContext _mlContext = null;
        private static object _isLocked = new object();
        private static ITransformer _model = null!;
        private const string ModelFilePath = "seminar-model.zip";

        private readonly ESeminarsContext Context;

        public RecommenderService(ESeminarsContext context)
        {
            Context = context;
        }

        public List<Model.Models.Seminari> GetRecommendedSeminars(int korisnikId, int numberOfRecommendation = 4)
        {
            var allSeminars = Context.Seminaris
                .Include(s => s.Dojmovis).ThenInclude(d=>d.Korisnik)
                .Include(s => s.Kategorija)
                .Include(s => s.Korisnik)
                .Include(s=>s.Materijalis)
                .Include(s=>s.Predavac)
                .Include(s=>s.SponzoriSeminaris).ThenInclude(ss=>ss.Sponzor).Where(s=>s.StateMachine == "active")
                .ToList();

            var approvedReservations = Context.Rezervacijes.Where(r => r.KorisnikId == korisnikId && r.StateMachine == "approved").Include(r => r.Seminar).ToList();

            var attendedSeminars = approvedReservations.Select(r => r.Seminar).Distinct().ToList();

            var onWaitReservations = Context.Rezervacijes.Where(r => r.KorisnikId == korisnikId && r.StateMachine == "rejected").Include(r => r.Seminar).Select(r => r.Seminar).Distinct().ToList();

            var candidatesForRecommendation = allSeminars.Where(s => !approvedReservations.Any(ar => ar.Seminar.SeminarId == s.SeminarId) &&
            !onWaitReservations.Any(or => or.SeminarId == s.SeminarId)).ToList();

            if (!approvedReservations.Any())
            {
                return candidatesForRecommendation.Take(numberOfRecommendation).Select(s => new Model.Models.Seminari
                {
                    SeminarId = s.SeminarId,
                    Naslov = s.Naslov,
                    Opis = s.Opis,
                    DatumVrijeme = s.DatumVrijeme,
                    Lokacija = s.Lokacija,
                    Kapacitet = s.Kapacitet,
                    Zauzeti = s.Zauzeti,
                    Korisnik = s.Korisnik == null ? null : new Model.Models.Korisnici
                    {
                        KorisnikId = s.KorisnikId ?? 0,
                        Ime = s.Korisnik.Ime,
                        Prezime = s.Korisnik.Prezime,
                        Email = s.Korisnik.Email,
                        DatumRodjenja = s.Korisnik.DatumRodjenja
                    },
                    Predavac = s.Predavac == null ? null : new Model.Models.Predavaci
                    {
                        PredavacId = s.PredavacId ?? 0,
                        Ime = s.Predavac.Ime,
                        Prezime = s.Predavac.Prezime,
                        Biografija = s.Predavac.Biografija,
                        Email = s.Predavac.Email,
                        Telefon = s.Predavac.Telefon
                    },
                    Kategorija = s.Kategorija == null ? null : new Model.Models.Kategorije
                    {
                        KategorijaId = s.KategorijaId ?? 0,
                        Naziv = s.Kategorija.Naziv,
                        Opis = s.Kategorija.Opis
                    },
                    Dojmovis = s.Dojmovis?.Select(d => new Model.Models.Dojmovi
                    {
                        DojamId = d.DojamId,
                        SeminarId = d.SeminarId,
                        KorisnikId = d.KorisnikId,
                        Ocjena = d.Ocjena,
                        Korisnik = d.Korisnik == null ? null : new Model.Models.Korisnici
                        {
                            KorisnikId = d.Korisnik.KorisnikId,
                            Ime = d.Korisnik.Ime,
                            Prezime = d.Korisnik.Prezime,
                            Email = d.Korisnik.Email,
                            DatumRodjenja = d.Korisnik.DatumRodjenja,
                        }
                    }).ToList(),
                    SponzoriSeminaris = s.SponzoriSeminaris?.Select(sp => new Model.Models.SponzoriSeminari
                    {
                        SponzoriSeminariId = sp.SponzoriSeminariId,
                        SponzorId = sp.SponzorId,
                        SeminarId = sp.SeminarId,
                        Sponzor = sp.Sponzor == null ? null : new Model.Models.Sponzori
                        {
                            SponzorId = sp.Sponzor.SponzorId,
                            Naziv = sp.Sponzor.Naziv,
                            Email = sp.Sponzor.Email,
                            Telefon = sp.Sponzor.Telefon,
                            KontaktOsoba = sp.Sponzor.KontaktOsoba
                        }
                    }).ToList(),
                    Materijalis = s.Materijalis?.Select(m => new Model.Models.Materijali
                    {
                        MaterijalId = m.MaterijalId,
                        SeminarId = m.SeminarId ?? 0,
                        Naziv = m.Naziv,
                        Putanja = m.Putanja

                    }).ToList(),
                }).ToList();
            }
            var seminarTextData = candidatesForRecommendation.Select(s => new
            {
                Seminar = s,
                Text = $"{s.Naslov} {s.Opis}"
            }).ToList();

            var userProfileText = string.Join(" ", approvedReservations.Select(s => $"{s.Seminar.Naslov} {s.Seminar.Opis}"));

            var mlContext = new MLContext();
            var data = seminarTextData.Select(s => new SeminarText { Text = s.Text }).ToList();

            data.Add(new SeminarText { Text = userProfileText });

            var dataView = mlContext.Data.LoadFromEnumerable(data);

            var pipeline = mlContext.Transforms.Text.FeaturizeText("Features", nameof(SeminarText.Text));
            var model = pipeline.Fit(dataView);
            var transformedData = model.Transform(dataView);

            var vectors = transformedData.GetColumn<float[]>("Features").ToArray();
            var userVector = vectors.Last();
            var seminarVectors = vectors.Take(vectors.Length - 1).ToList();

            var recommend = seminarVectors.Select((v, i) => new
            {
                Score = CosineSimilarity(userVector, v),
                Seminar = seminarTextData[i].Seminar
            }).OrderByDescending(s => s.Score)
            .Take(numberOfRecommendation)
            .Select(x => new Model.Models.Seminari
            {
                SeminarId = x.Seminar.SeminarId,
                Naslov = x.Seminar.Naslov,
                Opis = x.Seminar.Opis,
                DatumVrijeme = x.Seminar.DatumVrijeme,
                Lokacija = x.Seminar.Lokacija,
                Kapacitet = x.Seminar.Kapacitet,
                Zauzeti = x.Seminar.Zauzeti,

                Korisnik = x.Seminar.Korisnik == null ? null : new Model.Models.Korisnici
                {
                    KorisnikId = x.Seminar.KorisnikId ?? 0,
                    Ime = x.Seminar.Korisnik.Ime,
                    Prezime = x.Seminar.Korisnik.Prezime,
                    Email = x.Seminar.Korisnik.Email,
                    DatumRodjenja = x.Seminar.Korisnik.DatumRodjenja
                },
                Predavac = x.Seminar.Predavac == null ? null : new Model.Models.Predavaci
                {
                    PredavacId = x.Seminar.PredavacId ?? 0,
                    Ime = x.Seminar.Predavac.Ime,
                    Prezime = x.Seminar.Predavac.Prezime,
                    Biografija = x.Seminar.Predavac.Biografija,
                    Email = x.Seminar.Predavac.Email,
                    Telefon = x.Seminar.Predavac.Telefon
                },
                Kategorija = x.Seminar.Kategorija == null ? null : new Model.Models.Kategorije
                {
                    KategorijaId = x.Seminar.KategorijaId ?? 0,
                    Naziv = x.Seminar.Kategorija.Naziv,
                    Opis = x.Seminar.Kategorija.Opis
                },
                Dojmovis = x.Seminar.Dojmovis?.Select(d => new Model.Models.Dojmovi
                {
                    DojamId = d.DojamId,
                    SeminarId = d.SeminarId,
                    KorisnikId = d.KorisnikId,
                    Ocjena = d.Ocjena,
                    Korisnik = d.Korisnik == null ? null : new Model.Models.Korisnici
                    {
                        KorisnikId = d.Korisnik.KorisnikId,
                        Ime = d.Korisnik.Ime,
                        Prezime = d.Korisnik.Prezime,
                        Email = d.Korisnik.Email,
                        DatumRodjenja = d.Korisnik.DatumRodjenja,
                    }
                }).ToList(),
                SponzoriSeminaris = x.Seminar.SponzoriSeminaris?.Select(sp => new Model.Models.SponzoriSeminari
                {
                    SponzoriSeminariId = sp.SponzoriSeminariId,
                    SponzorId = sp.SponzorId,
                    SeminarId = sp.SeminarId,
                    Sponzor = sp.Sponzor == null ? null : new Model.Models.Sponzori
                    {
                        SponzorId = sp.Sponzor.SponzorId,
                        Naziv = sp.Sponzor.Naziv,
                        Email = sp.Sponzor.Email,
                        Telefon = sp.Sponzor.Telefon,
                        KontaktOsoba = sp.Sponzor.KontaktOsoba
                    }
                }).ToList(),
                Materijalis = x.Seminar.Materijalis?.Select(m => new Model.Models.Materijali
                {
                    MaterijalId = m.MaterijalId,
                    SeminarId = m.SeminarId ?? 0,
                    Naziv = m.Naziv,
                    Putanja = m.Putanja
                }).ToList()

            }).ToList();

            return recommend;

        }

        public void TrainModel()
        {
            lock (_isLocked) {

                if (_mlContext == null)
                {
                    _mlContext = new MLContext();
                }
                if (File.Exists(ModelFilePath))
                {
                    using(var stream = new FileStream(ModelFilePath,FileMode.Open,FileAccess.Read, FileShare.Read))
                    {
                        _model = _mlContext.Model.Load(stream, out var _);
                    }
                }
                else
                {
                    var allReservations = Context.Rezervacijes.ToList();

                    var approvedReservations = Context.Rezervacijes.Where(r => r.StateMachine == "approved").ToList();

                    var data = allReservations.Select(r => new KorisnikSeminarInteraction
                    {
                        KorisnikId = (uint)r.KorisnikId,
                        SeminarId = (uint)r.SeminarId,
                        Label = approvedReservations.Any(ar => ar.KorisnikId == r.KorisnikId && ar.SeminarId == r.SeminarId) ? 1f : 0f
                    }).ToList();

                    var trainingData = _mlContext.Data.LoadFromEnumerable(data);
                    var options = new Microsoft.ML.Trainers.MatrixFactorizationTrainer.Options
                    {
                        MatrixColumnIndexColumnName = nameof(KorisnikSeminarInteraction.KorisnikId),
                        MatrixRowIndexColumnName = nameof(KorisnikSeminarInteraction.SeminarId),
                        LabelColumnName = nameof(KorisnikSeminarInteraction.Label),
                        LossFunction = Microsoft.ML.Trainers.MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass,
                        Alpha = 0.01f,
                        Lambda = 0.025f,
                        NumberOfIterations = 100,
                        ApproximationRank = 100
                    };

                    var est = _mlContext.Recommendation().Trainers.MatrixFactorization(options);
                    _model = est.Fit(trainingData);
                    using (var stream = new FileStream(ModelFilePath, FileMode.Create, FileAccess.Write, FileShare.Write))
                    {
                        _mlContext.Model.Save(_model, trainingData.Schema, stream);
                    }
                }
            }
        }


        public class KorisnikSeminarInteraction
        {
            [KeyType(count: 1000)]
            public uint KorisnikId { get; set; }
            [KeyType(count: 1000)]
            public uint SeminarId { get; set; }
            public float Label { get; set; }
        }
        public class SeminarPrediction
        {
            public float Score { get; set; }
        }
        public class SeminarText
        {
            public string Text { get; set; } = "";
        }
        private float CosineSimilarity(float[] v1, float[] v2)
        {
            float dot = 0;
            float normA = 0;
            float normB = 0;

            for (int i = 0; i < v1.Length; i++)
            {
                dot += v1[i] * v2[i];
                normA += v1[i] * v1[i];
                normB += v2[i] * v2[i];
            }

            return dot / ((float)Math.Sqrt(normA) * (float)Math.Sqrt(normB) + 1e-5f);
        }
    }
}
