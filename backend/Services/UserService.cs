using backend.Models;
using backend.Models.entity;
using backend.IServices;

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
            return _context.Users.FirstOrDefault(u => u.Email == email && u.Password == password);
        }

        public User RegisterUser(string username, string email, string password)
        {
            if (UserExists(email))
            {
                return null;
            }

            var newRegisteredUser = new User
            {
                Username = username,
                Email = email,
                Password = password,
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
