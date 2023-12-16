using Microsoft.AspNetCore.Mvc;
using backend.Services;
using backend.Models.request;

namespace backend.Controllers
{
    [Route("api/user")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly UserService _userService;
        public UserController(UserService userService)
        {
            _userService = userService;
        }

        [HttpPost("login")]
        public IActionResult Login([FromBody] userLoginRequest loginRequest)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }
                var existingUser = _userService.UserExists(loginRequest.email);

                if (existingUser == true)
                {
                    var authenticatedUser = _userService.AuthenticateUser(loginRequest.email, loginRequest.password);
                    if (authenticatedUser != null)
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
            catch
            {
                return StatusCode(500, new { Message = "Internal server error" });
            }         
        }

        [HttpPost("register")]
        public IActionResult Register([FromBody] userRegisterRequest registrationRequest)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }
                var registeredUser = _userService.RegisterUser(
                registrationRequest.username,
                registrationRequest.email,
                registrationRequest.password
                );

                if (registeredUser != null)
                {
                    var userResponse = new
                    {
                        UserId = registeredUser.UserId,
                        Username = registeredUser.Username,
                        Email = registeredUser.Email
                    };

                    return Ok(new { Message = "Registration successful", User = userResponse });
                }
                else
                {
                    return Conflict(new { Message = "User with the same email already exists" });
                }
            }
            catch 
            {
                return StatusCode(500, new { Message = "Internal server error" });
            }          
        }
    }
}
