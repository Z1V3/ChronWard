using System;
using backend.Models;
using System.Linq;
using backend.Models.entity;

namespace backend.Services
{
    public class UserService
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
    }
}
