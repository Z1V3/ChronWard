using backend.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using backend.Models.request;
using backend.Models.entity;

namespace backend.Controllers
{
    [Route("api/card")]
    [ApiController]
    public class CardController : ControllerBase
    {
        private readonly CardService _cardService;
        public CardController(CardService cardService)
        {
            _cardService = cardService;
        }

        [HttpGet("getUserCards/{userID}")]
        public async Task<IActionResult> GetUserCards(int userID)
        {
            try
            {
                var cards = await _cardService.GetCardsByUserId(userID);
                if (cards == null || cards.Count == 0)
                {
                    return NotFound(new { Message = "No cards found for this user" });
                }

                return Ok(cards);
            }
            catch (Exception ex)
            {
                return StatusCode(500, "Internal Server Error");
            }
        }

        [HttpPost("addNewCard")]
        public async Task<IActionResult> AddNewCard([FromBody] cardAddRequest cardAddReq)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }

                var newCard = await _cardService.AddNewCard(cardAddReq.Value, cardAddReq.UserID.Value);

                if (newCard != null)
                {
                    return Ok(new { Message = "New card added" });
                }

                return Conflict(new { Message = "Card not added" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Message = "Internal server error" });
            }
        }

    }
}
