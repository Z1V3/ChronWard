using backend.Models;
using backend.Models.entity;
using backend.IServices;
using BCrypt.Net;
using Google.Apis.Auth;

namespace backend.Services
{
    public class UserService: IUserService
    {
        private readonly EvChargeDB _context;

        public UserService(EvChargeDB context)
        {
            _context = context;
        }
        public User GetUserByEmail(string email)
        {
            return _context.Users.FirstOrDefault(u => u.Email == email);
        }

        public bool AuthenticateUser(string password, string hashedPassword)
        { 
            bool isPasswordValid = VerifyPassword(password, hashedPassword);
            if (isPasswordValid)
            {
               return true;
            }
            return false;
        }
        public static string HashPassword(string password)
        {
            string salt = BCrypt.Net.BCrypt.GenerateSalt();
            string hashedPassword = BCrypt.Net.BCrypt.HashPassword(password, salt);

            return hashedPassword;
        }

        public static bool VerifyPassword(string password, string hashedPassword)
        {
            return BCrypt.Net.BCrypt.Verify(password, hashedPassword);
        }

        public User RegisterUser(string username, string email, string password)
        {
            if (GetUserByEmail(email) != null)
            {
                return null;
            }
            string hashedPassword = HashPassword(password);
            var newRegisteredUser = new User
            {
                Username = username,
                Email = email,
                Password = hashedPassword,
                Active = true,
                Created = DateTime.Now,
                Role = "user",
                
            };

            _context.Users.Add(newRegisteredUser);
            _context.SaveChanges();

            return newRegisteredUser;
        }

        public User CreateUserFromGoogleSignIn(string email, string name)
        {
            var newRegisteredUser = new User
            {
                Username = name,
                Email = email,
                Active = true,
                Created = DateTime.Now,
                Role = "user",
                Password = "lozinka"
            };

            _context.Users.Add(newRegisteredUser);
            _context.SaveChanges();

            return newRegisteredUser;
        }
        public GoogleJsonWebSignature.Payload ValidateGoogleIdToken(string googleSignInToken)
        {
            var validationSettings = new GoogleJsonWebSignature.ValidationSettings();
            var payload = GoogleJsonWebSignature.ValidateAsync(googleSignInToken, validationSettings).Result;

            return payload;
        }
        public string UserPasswordReset(User user)
        {
            string newPassword = GenerateNewPassword();
            string hashedPassword = HashPassword(newPassword);
            SaveNewPassword(user, hashedPassword);
            return newPassword;
        }
        public string GenerateNewPassword()
        {
            string newPassword;
            const string allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            var random = new Random();

            newPassword = new string(Enumerable.Repeat(allowedChars, 8)
                .Select(s => s[random.Next(s.Length)]).ToArray());

            return newPassword;
        }
        private void SaveNewPassword(User user, string hashedPassword)
        {
            user.Password = hashedPassword;
            _context.SaveChanges();
        }
    }
}
