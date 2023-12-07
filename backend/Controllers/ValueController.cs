using backend.Models.entity;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace backend.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class ValueController : ControllerBase
    {
        public ValueController()
        {
        }

        [HttpGet(Name = "GetValue")]
        public IEnumerable<Value> Get()
        {
            var value = new Value
            {
                ID = 1,
                Name = "blabla"
            };

            // Corrected: Wrap the single user in an enumerable (e.g., an array or a list)
            return new List<Value> { value };
        }
    }
}
