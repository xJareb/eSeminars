using eSeminars.Model.Message;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSeminars.Services.RabbitMQ
{
    public interface IRabbitMQService
    {
        Task SendEmail(Email email);
    }
}
