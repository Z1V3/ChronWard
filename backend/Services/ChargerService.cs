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
            try
            {
                await _context.SaveChangesAsync();
                return newCharger;
            }
            catch (Exception ex)
            {
                throw new Exception("Error saving new charger to the database", ex);
            }        
        }
    }
}
