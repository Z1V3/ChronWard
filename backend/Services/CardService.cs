using System;
using backend.Models;
using System.Linq;
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
    }
}
