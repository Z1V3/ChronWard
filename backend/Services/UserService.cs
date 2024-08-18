﻿using backend.Models;
using backend.Models.entity;
using backend.IServices;
using BCrypt.Net;
using Google.Apis.Auth;
using Microsoft.EntityFrameworkCore;

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

        public async Task<List<object>> GetUserByUserId(int userId)
        {
            var user = await _context.Users
                    .Where(u => u.UserId == userId)
                    .Select(u => new {UserId = u.UserId, Role = u.Role})
                    .ToListAsync();

            return user.Cast<object>().ToList();
        }

        public async Task<User> GetFullUserByUserId(int userId)
        {
            var user = await _context.Users.FirstOrDefaultAsync(u => u.UserId == userId);
            return user;
        }

        public async Task<decimal> GetWalletByUserId(int userId)
        {
            var userWallet = await _context.Users
                .Where(u => u.UserId == userId)
                .Select(u => u.Wallet)
                .FirstOrDefaultAsync();

            return userWallet;
        }

        public async Task<User> UpdateWalletValue(int userId, decimal value)
        {
            User user = await GetFullUserByUserId(userId);
            if (user != null)
            {
                user.Wallet += value;

                await _context.SaveChangesAsync();
            }
            return user;
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
                Wallet = 0
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
                Wallet = 0
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
