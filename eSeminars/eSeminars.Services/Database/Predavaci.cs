﻿using System;
using System.Collections.Generic;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;

namespace eSeminars.Services.Database;

public partial class Predavaci
{
    public int PredavacId { get; set; }

    public string Ime { get; set; } = null!;

    public string Prezime { get; set; } = null!;

    public string Biografija { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string Telefon { get; set; } = null!;

    public virtual ICollection<Seminari> Seminaris { get; set; } = new List<Seminari>();
}
