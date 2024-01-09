using backend.Models;
using backend.Models.entity;
using backend.IServices;
using BCrypt.Net;

namespace backend.Services
{
    public class UserService: IUserService
    {
        private readonly EvChargeDB _context;

        public UserService(EvChargeDB context)
        {
            _context = context;
        }

        public bool UserExists(string email)
        {
            return _context.Users.Any(u => u.Email == email);
        }

        public User AuthenticateUser(string email, string password)
        { 
            User user = _context.Users.FirstOrDefault(u => u.Email == email);
            bool isPasswordValid = VerifyPassword(password, user.Password);
            if (isPasswordValid)
            {
               return user;
            }
            return null;
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
            if (UserExists(email))
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
                Role = "user"
            };

            _context.Users.Add(newRegisteredUser);
            _context.SaveChanges();

            return newRegisteredUser;
        }
    }
}
