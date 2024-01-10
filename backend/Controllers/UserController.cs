using Microsoft.AspNetCore.Mvc;
using backend.IServices;
using backend.Models.request;

namespace backend.Controllers
{
    [Route("api/user")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly IUserService _iUserService;
        public UserController(IUserService iUserService)
        {
            _iUserService = iUserService;
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
                var existingUser = _iUserService.GetUserByEmail(loginRequest.email);

                if (existingUser != null)
                {
                    bool isPasswordValid = _iUserService.AuthenticateUser(loginRequest.password, existingUser.Password);

                    if (isPasswordValid)
                    {
                        var userResponse = new
                        {
                            UserId = existingUser.UserId,
                            Username = existingUser.Username,
                            Email = existingUser.Email
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
                var registeredUser = _iUserService.RegisterUser(
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
        [HttpPost("google_login")]
        public IActionResult GoogleLogin([FromBody] userGoogleLoginRequest googleSignInRequest)
        {
            try
            {
                var payload =_iUserService.ValidateGoogleIdToken(googleSignInRequest.token);

                if (payload != null)
                {
                    string userEmail = payload.Email;
                    string userName = payload.Name;

                    var existingUser = _iUserService.GetUserByEmail(userEmail);

                    if (existingUser != null)
                    {
                        var userResponse = new
                        {
                            UserId = existingUser.UserId,
                            Username = existingUser.Username,
                            Email = existingUser.Email,
                        };
                        return Ok(new { Message = "Login successful", User = userResponse });
                    }
                    else
                    {
                        var newUser = _iUserService.CreateUserFromGoogleSignIn(userEmail, userName);

                        if (newUser != null)
                        {
                            var userResponse = new
                            {
                                UserId = newUser.UserId,
                                Username = newUser.Username,
                                Email = newUser.Email,
                            };
                            return Ok(new { Message = "Registration successful", User = userResponse });
                        }
                        else
                        {
                            return Conflict(new { Message = "The user could not be created" });
                        }
                    }
                }
                else
                {
                    return BadRequest(new { Message = "Invalid Google ID token" });
                }
            }
            catch
            {
                return StatusCode(500, new { Message = "Internal server error"});
            }
        }

        [HttpPost("forgotPassword")]
        public IActionResult ForgotPassword([FromBody] userForgotPasswordRequest forgotPasswordRequest)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }

                var user = _iUserService.GetUserByEmail(forgotPasswordRequest.email);
                if (user != null)
                {
                    string newPassword = _iUserService.UserPasswordReset(user);


                    return Ok(new { Message = "New password sent to user's email address", newPassword });
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
    }
}
