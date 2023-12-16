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
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }

                var newEvent = await _eventService.CreateEvent(eventCreateReq.startTime.Value, eventCreateReq.endTime.Value, eventCreateReq.chargeTime.Value, eventCreateReq.volume.Value, eventCreateReq.price.Value, eventCreateReq.userID.Value, eventCreateReq.chargerID.Value);
                if (newEvent == null)
                {
                    return Conflict(new { Message = "Event not created" });
                }
                return Ok(new { Message = "Event created successfully" });               
            }
            catch
            {
                return StatusCode(500, new { Message = "Internal server error" });
            }
        }

        [HttpGet("getEventsByUserID/{userID}")]
        public async Task<IActionResult> GetEventsByUserIdAction(int userID)
        {
            try
            {
                var events = await _eventService.GetEventsByUserId(userID);
                if (events == null || events.Count == 0)
                {
                    return Conflict(new { Message = "Events for this user not found" });
                }
                return Ok(events);
            }
            catch
            {
                return StatusCode(500, "Internal Server Error");
            }
        }
    }
}