using System;
using backend.Models;
using System.Linq;
using backend.Models.entity;
using Microsoft.EntityFrameworkCore;
using System.ComponentModel;
using Npgsql.Internal.TypeHandlers.NumericHandlers;
using Microsoft.VisualBasic;

namespace backend.Services
{
    public class EventService
    {
        private readonly EvChargeDB _context;
        public EventService(EvChargeDB context)
        {
            _context = context;
        }

        public async Task<List<object>> GetEventsByUserId(int userId)
        {
            try
            {
                var events = await _context.Events
                    .Where(e => e.UserId == userId)
                    .Select(e => new { ChargeTime = e.ChargeTime, Volume = e.Volume, Price = e.Price })
                    .ToListAsync();

                return events.Cast<object>().ToList();
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public async Task CreateEvent(DateTime start, DateTime end, TimeSpan timespan, decimal volume, decimal price, int userId, int chargerId)
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

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException ex)
            {
                throw new Exception("Error saving to the database", ex);
            }
        }
    }
}