using System.Net;
using eSeminars.Model;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace eSeminars.API.Filters
{
    public class ExceptionFilter : ExceptionFilterAttribute
    {
        public ILogger<ExceptionFilter> _Logger { get; set; }
        public ExceptionFilter(ILogger<ExceptionFilter> logger)
        {
            _Logger = logger;
        }
        public override void OnException(ExceptionContext context)
        {
            _Logger.LogError(context.Exception, context.Exception.Message);
            if (context.Exception is UserException)
            {
                context.ModelState.AddModelError("userError",context.Exception.Message);
                context.HttpContext.Response.StatusCode = (int)HttpStatusCode.BadGateway;
            }
            else
            {
                context.ModelState.AddModelError("ERROR", "Server side error, please check logs");
                context.HttpContext.Response.StatusCode = (int)HttpStatusCode.InternalServerError;
            }

            var list = context.ModelState.Where(x => x.Value.Errors.Count() > 0)
                .ToDictionary(x => x.Key, y => y.Value.Errors.Select(z => z.ErrorMessage));

            context.Result = new JsonResult(new { errors = list });
        }
    }
}
