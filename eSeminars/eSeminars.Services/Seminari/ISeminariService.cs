﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eSeminars.Model.Requests;
using eSeminars.Model.SearchObjects;

namespace eSeminars.Services.Seminari
{
    public interface ISeminariService : ICRUDService<Model.Models.Seminari,SeminariSearchObject,SeminariInsertRequest,SeminariUpdateRequest>
    {
    }
}
