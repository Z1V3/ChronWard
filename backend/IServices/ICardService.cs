using backend.Models.entity;

namespace backend.IServices
{
    public interface ICardService
    {
        Task<List<object>> GetCardsByUserId(int userID);
        Task<Card> AddNewCard(string value, int userID);
        Task<Card> AuthenticateCard(string value);
        Task<Card> GetCardByValue(string value);
    }
}
