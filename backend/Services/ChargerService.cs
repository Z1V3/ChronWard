using backend.Models;
using backend.Models.entity;
using Microsoft.EntityFrameworkCore;
using backend.IServices;

namespace backend.Services
{
    public class ChargerService: IChargerService
    {
        private readonly EvChargeDB _context;
        public ChargerService(EvChargeDB context)
        {
            _context = context;
        }

        public async Task<Charger> GetChargerByName(string name)
        {
            var charger = await _context.Chargers.FirstOrDefaultAsync(c => c.Name == name);
            return charger;
        }
        public async Task<Charger> CreateNewCharger(string name, decimal latitude, decimal longitude, int creator)
        {
            if (latitude < -90 || latitude > 90 || longitude < -180 || longitude > 180)
            {
                return null;
            }
            latitude = Math.Round(latitude, 4);
            longitude = Math.Round(longitude, 4);
            var newCharger = new Charger
            {
                Name = name,
                Latitude = latitude,
                Longitude = longitude,
                Created = DateTime.Now,
                Creator = creator,
                Lastsync = DateTime.Now,
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
                if (existingCharger.Name != name)
                {
                    Charger duplicateCharger = await GetChargerByName(name);

                    if (duplicateCharger != null && duplicateCharger.ChargerId != chargerID)
                    {
                        return null;
                    }
                }

                if (latitude < -90 || latitude > 90 || longitude < -180 || longitude > 180)
                {
                    return null;
                }
                latitude = Math.Round(latitude, 4);
                longitude = Math.Round(longitude, 4);

                existingCharger.Name = name;
                existingCharger.Latitude = latitude;
                existingCharger.Longitude = longitude;
                existingCharger.Active = active;

                await _context.SaveChangesAsync();

                return existingCharger;
            }
            return null;
        }

        public async Task<Charger> UpdateChargerAvailability(int chargerID, bool occupied)
        {
            Charger existingCharger = await GetChargerByID(chargerID);
            if (existingCharger != null)
            {
                existingCharger.Occupied = occupied;
                existingCharger.Lastsync = DateTime.Now;

                await _context.SaveChangesAsync();
            }
            return existingCharger;
        }

        public Task<int> GetTotalChargersCount()
        {
            return _context.Chargers.CountAsync();
        }

        public Task<int> GetDeactivatedChargersCount()
        {
            return _context.Chargers.CountAsync(c => !c.Active);
        }

        public Task<int> GetFreeChargersCount()
        {
            return _context.Chargers.CountAsync(c => c.Active && !c.Occupied);
        }

        public Task<int> GetOccupiedChargersCount()
        {
            return _context.Chargers.CountAsync(c => c.Active && c.Occupied);
        }
        public async Task<List<Charger>> GetAllChargers()
        {
            var chargers = await _context.Chargers.ToListAsync();
            return chargers;
        }

        public async Task<bool> DeleteCharger(Charger charger)
        {
            if (charger == null)
            {
                return false;
            }

            _context.Chargers.Remove(charger);
            await _context.SaveChangesAsync();

            return true;
        }
    }
}
