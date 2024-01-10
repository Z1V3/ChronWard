using backend.IServices;
using Microsoft.AspNetCore.Mvc;
using backend.Models.request;

namespace backend.Controllers
{
    [Route("api/charger")]
    [ApiController]
    public class ChargerController : ControllerBase
    {
        private readonly IChargerService _iChargerService;
        public ChargerController(IChargerService iChargerService)
        {
            _iChargerService = iChargerService;
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
                var chargerWithSameName = await _iChargerService.GetChargerByName(chargerCreateReq.Name);
                if (chargerWithSameName != null)
                {
                    return Conflict(new { Message = "Charger with the same name already exists" });
                }
                var newCharger = await _iChargerService.CreateNewCharger(chargerCreateReq.Name, chargerCreateReq.Latitude.Value, chargerCreateReq.Longitude.Value, chargerCreateReq.Creator.Value);

                if (newCharger != null)
                {
                    return Ok(new { Message = "New charger created" });
                }

                return Conflict(new { Message = "Charger not created" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Message = "Internal server error", ExceptionMessage = ex.Message });
            }
        }

        [HttpPost("updateCharger")]
        public async Task<IActionResult> updateCharger([FromBody] chargerUpdateRequest chargerUpdateReq)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }
                var updatedCharger = await _iChargerService.UpdateExistingCharger(chargerUpdateReq.ChargerID.Value, chargerUpdateReq.Name, chargerUpdateReq.Latitude.Value, chargerUpdateReq.Longitude.Value, chargerUpdateReq.Active.Value);

                if (updatedCharger != null)
                {
                    return Ok(new { Message = "Charger successfully updated" });
                }

                return Conflict(new { Message = "Charger not updated" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Message = "Internal server error", ExceptionMessage = ex.Message });
            }
        }

        [HttpGet("getChargersStatistics")]
        public async Task<IActionResult> GetChargersStatistics()
        {
            try
            {
                var totalNumberOfChargers = await _iChargerService.GetTotalChargersCount();
                var numberOfOccupiedChargers = await _iChargerService.GetOccupiedChargersCount();
                var numberOfFreeChargers = await _iChargerService.GetFreeChargersCount();
                var numberOfDeactivatedChargers = await _iChargerService.GetDeactivatedChargersCount();
                var response = new
                {
                    TotalNumberOfChargers = totalNumberOfChargers,
                    NumberOfOccupiedChargers = numberOfOccupiedChargers,
                    NumberOfFreeChargers = numberOfFreeChargers,
                    NumberOfDeactivatedChargers = numberOfDeactivatedChargers
                };

                return Ok(new { Message = "Statistics data successfully returned", Statistics = response });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Message = "Internal server error", ExceptionMessage = ex.Message });
            }
        }

        [HttpPost("updateChargerAvailability")]
        public async Task<IActionResult> UpdateChargerAvailability([FromBody] chargerAvailabilityRequest chargerAvailabilityReq)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }
                
                var updatedCharger = await _iChargerService.UpdateChargerAvailability(chargerAvailabilityReq.ChargerID.Value, chargerAvailabilityReq.Occupied.Value);
                if (updatedCharger != null)
                {
                    return Ok(new { Message = "Charger availability updated successfully"});
                }
                else
                {
                    return NotFound(new { Message = "Charger not found" });
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Message = "Internal server error", ExceptionMessage = ex.Message });
            }
        }
    }
}
