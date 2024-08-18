using backend.Models.entity;
using Google.Apis.Auth;

namespace backend.IServices
{
    public interface IUserService
    {
        User GetUserByEmail(string email);
        Task<List<object>> GetUserByUserId(int userId);
        Task<User> GetFullUserByUserId(int userId);
        Task<decimal> GetWalletByUserId(int userId);
        Task<User> UpdateWalletValue(int userId, decimal value);
        bool AuthenticateUser(string password, string hashedPassword);
        User RegisterUser(string username, string email, string password);
        User CreateUserFromGoogleSignIn(string email, string name);
        GoogleJsonWebSignature.Payload ValidateGoogleIdToken(string googleSignInToken);
        string UserPasswordReset(User user);
    }
}

