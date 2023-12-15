using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using backend.Services;
using backend.Models.request;

namespace backend.Controllers
{
    [Route("api/event")]
    [ApiController]
    public class EventController : ControllerBase
    {
        private readonly EventService _eventService;
        public EventController(EventService eventService)
        {
            _eventService = eventService;
        }

        [HttpPost("createEvent")]
        public async Task<IActionResult> CreateEvent([FromBody] eventCreateRequest eventCreateReq)
        {
            if (eventCreateReq == null || !ModelState.IsValid)
            {
                return BadRequest(new { Message = "Invalid event data" });
            }

            try
            {     
                await _eventService.CreateEvent(eventCreateReq.startTime, eventCreateReq.endTime, eventCreateReq.chargeTime, eventCreateReq.volume, eventCreateReq.price, eventCreateReq.userID, eventCreateReq.chargerID);
                return Ok(new { Message = "Event created successfully" });               
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Message = "Internal server error" });
            }
        }

        [HttpGet("getEventsByUserID/{userId}")]
        public async Task<IActionResult> GetEventsByUserIdAction(int userId)
        {
            try
            {
                var events = await _eventService.GetEventsByUserId(userId);
                return Ok(events);
            }
            catch (Exception ex)
            {
                return StatusCode(500, "Internal Server Error");
            }
        }
    }
}