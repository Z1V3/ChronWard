using System;
using backend.Models;
using System.Linq;
using backend.Models.entity;
using Microsoft.EntityFrameworkCore;

namespace backend.Services
{
    public class ChargerService
    {
        private readonly EvChargeDB _context;
        public ChargerService(EvChargeDB context)
        {
            _context = context;
        }
        public async Task<Charger> CreateNewCharger(string name, decimal latitude, decimal longitude, int creator)
        {

            var newCharger = new Charger
            {
                Name = name,
                Latitude = latitude,
                Longitude = longitude,
                Created = DateTime.UtcNow,
                Creator = creator,
                Lastsync = DateTime.UtcNow,
                Active = true,
                Occupied = false
            };

            _context.Chargers.Add(newCharger);
            await _context.SaveChangesAsync();
            return newCharger;   
        }

        public async Task<Charger> GetChargerByID(int chargerID)
        {
            var charger = await _context.Chargers.FirstOrDefaultAsync(c => c.ChargerId == chargerID);
            return charger;
        }

        public async Task<Charger> UpdateExistingCharger(int chargerID, string name, decimal latitude, decimal longitude, bool active)
        {
            Charger existingCharger = await GetChargerByID(chargerID);
            if (existingCharger != null)
            {
                existingCharger.Name = name;
                existingCharger.Latitude = latitude;
                existingCharger.Longitude = longitude;
                existingCharger.Active = active;

                await _context.SaveChangesAsync();              
            }
            return existingCharger;
        }
    }
}
