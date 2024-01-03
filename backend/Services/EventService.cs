using backend.Models;
using backend.Models.entity;
using Microsoft.EntityFrameworkCore;
using backend.IServices;

namespace backend.Services
{
    public class EventService: IEventService
    {
        private readonly EvChargeDB _context;
        public EventService(EvChargeDB context)
        {
            _context = context;
        }

        public async Task<List<object>> GetEventsByUserId(int userId)
        {
            var events = await _context.Events
                    .Where(e => e.UserId == userId)
                    .Select(e => new { StartTime = e.Starttime, EndTime = e.Endtime, ChargeTime = e.ChargeTime, Volume = e.Volume, Price = e.Price })
                    .ToListAsync();

            return events.Cast<object>().ToList();
        }

        public async Task<Event> CreateEvent(DateTime start, DateTime end, TimeSpan timespan, decimal volume, decimal price, int userId, int chargerId)
        {
            var newEvent = new Event
            {
                Starttime = start,
                Endtime = end,
                UserId = userId,
                ChargerId = chargerId,
                Volume = volume,
                ChargeTime = timespan,
                Price = price
            };

            _context.Events.Add(newEvent);
            await _context.SaveChangesAsync();
            return newEvent;
        }
    }
}