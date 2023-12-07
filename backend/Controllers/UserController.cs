using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using backend.Models;
using Microsoft.EntityFrameworkCore;
using backend.Services;
using backend.Models.request;
using backend.Models.entity;

namespace backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly EvChargeDB _context;
        private readonly UserService _userService;
        public UserController(EvChargeDB context, UserService userService)
        {
            _context = context;
            _userService = userService;
        }

        [HttpPost("login")]
        public IActionResult Login([FromBody] userLoginRequest loginRequest)
        {
            var existingUser = _userService.UserExists(loginRequest.email);
            
            if (existingUser == true)
            {
                var authenticatedUser = _userService.AuthenticateUser(loginRequest.email, loginRequest.password);
                if(authenticatedUser != null)
                {
                    var userResponse = new
                    {
                        UserId = authenticatedUser.UserId,
                        Username = authenticatedUser.Username,
                        Email = authenticatedUser.Email
                    };

                    return Ok(new { Message = "Login successful", User = userResponse });
                }
                else
                {
                    return Unauthorized(new { Message = "Wrong password" });
                }
            }
            else
            {
                return NotFound(new { Message = "User doesn't exist" });
            }
        }







        [HttpGet(Name = "GetAllUsers")]
        public async Task<List<User>> GetUsers()
        {
            return await _context.Users.ToListAsync();
        }

    }
}
