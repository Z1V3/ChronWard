using backend.Models.entity;

namespace backend.IServices
{
    public interface IEventService
    {
        Task<List<object>> GetEventsByUserId(int userId);
        Task<Event> CreateEvent(DateTime start, DateTime end, TimeSpan timespan, decimal volume, decimal price, int userId, int chargerId);
    }
}
