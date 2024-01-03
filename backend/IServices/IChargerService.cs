using backend.Models.entity;

namespace backend.IServices
{
    public interface IChargerService
    {
        Task<Charger> GetChargerByName(string name);
        Task<Charger> CreateNewCharger(string name, decimal latitude, decimal longitude, int creator);
        Task<Charger> GetChargerByID(int chargerID);
        Task<Charger> UpdateExistingCharger(int chargerID, string name, decimal latitude, decimal longitude, bool active);
        Task<Charger> UpdateChargerAvailability(int chargerID, bool occupied);
        Task<int> GetTotalChargersCount();
        Task<int> GetDeactivatedChargersCount();
        Task<int> GetFreeChargersCount();
        Task<int> GetOccupiedChargersCount();
    }
}
