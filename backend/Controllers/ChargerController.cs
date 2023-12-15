using backend.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using backend.Models.request;
using backend.Models.entity;

namespace backend.Controllers
{
    [Route("api/charger")]
    [ApiController]
    public class ChargerController : ControllerBase
    {
        private readonly ChargerService _chargerService;
        public ChargerController(ChargerService chargerService)
        {
            _chargerService = chargerService;
        }

        [HttpPost("createCharger")]
        public async Task<IActionResult> CreateCharger([FromBody] chargerCreateRequest chargerCreateReq)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }

                var newCharger = await _chargerService.CreateNewCharger(chargerCreateReq.Name, chargerCreateReq.Latitude.Value, chargerCreateReq.Longitude.Value, chargerCreateReq.Creator.Value);

                if (newCharger != null)
                {
                    return Ok(new { Message = "New charger created" });
                }

                return Conflict(new { Message = "Charger not created" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Message = "Internal server error" });
            }
        }

    }
}
