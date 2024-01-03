using backend.Models.entity;

namespace backend.IServices
{
    public interface IUserService
    {
        bool UserExists(string email);
        User AuthenticateUser(string email, string password);
        User RegisterUser(string username, string email, string password);
    }
}
