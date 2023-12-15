using backend.Models;
using backend.Models.entity;
using Microsoft.EntityFrameworkCore;

namespace backend.Services
{
    public class CardService
    {
        private readonly EvChargeDB _context;
        public CardService(EvChargeDB context)
        {
            _context = context;
        }

        public async Task<List<object>> GetCardsByUserId(int userID)
        {
            var cards = await _context.Cards
                .Where(e => e.UserId == userID)
                .Select(e => new { CardID = e.CardId, Active = e.Active})
                .ToListAsync();

            return cards.Cast<object>().ToList();
        }

        public async Task<Card> AddNewCard(string value, int userID)
        {
            var newCard = new Card
            {
                UserId = userID,
                Value = value,
                Active = true               
            };

            _context.Cards.Add(newCard);
            await _context.SaveChangesAsync();
            return newCard;
        }

        public async Task<Card> AuthenticateCard(string value)
        {
            var authenticatedCard = await _context.Cards
                .Where(card => card.Value == value && card.Active)
                .FirstOrDefaultAsync();
            return authenticatedCard;
        }

        public async Task<Card> GetCardByValue(string value)
        {
            var existingCard = await _context.Cards
                .Where(card => card.Value == value)
                .FirstOrDefaultAsync();

            return existingCard;
        }
    }
}
