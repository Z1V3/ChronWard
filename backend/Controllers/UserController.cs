using Microsoft.AspNetCore.Mvc;
using backend.IServices;
using backend.Models.request;
using backend.Services;

namespace backend.Controllers
{
    [Route("api/user")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly IUserService _iUserService;
        private readonly IEmailService _emailService;
        public UserController(IUserService iUserService, IEmailService emailService)
        {
            _iUserService = iUserService;
            _emailService = emailService;
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
                            Email = existingUser.Email,
                            Role = existingUser.Role
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
            catch (Exception ex)
            {
                return StatusCode(500, new { Message = "Internal server error", ExceptionMessage = ex.Message });
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
                    return Ok(new { Message = "Registration successful" });
                }
                else
                {
                    return Conflict(new { Message = "User with the same email already exists" });
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Message = "Internal server error", ExceptionMessage = ex.Message });
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
                            Role = existingUser.Role
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
                                Role = newUser.Role
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
            catch (Exception ex)
            {
                return StatusCode(500, new { Message = "Internal server error", ExceptionMessage = ex.Message });
            }
        }

        [HttpPost("forgotPassword")]
        public async Task<IActionResult>ForgotPassword([FromBody] userForgotPasswordRequest forgotPasswordRequest)
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

                    await _emailService.SendPasswordResetEmail(user.Username, user.Email, newPassword);

                    return Ok(new { Message = "New password sent to user's email address"});
                }
                else
                {
                    return NotFound(new { Message = "User doesn't exist" });
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Message = "Internal server error", ExceptionMessage = ex.Message});
            }
        }

        [HttpGet("getUserByUserId/{userID}")]
        public async Task<IActionResult> GetUserByUserId(int userID)
        {
            try
            {
                var user = await _iUserService.GetUserByUserId(userID);
                if (user == null)
                {
                    return Conflict(new { Message = "User not found" });
                }
                return Ok(user);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Message = "Internal server error", ExceptionMessage = ex.Message });
            }
        }

        [HttpGet("getWalletByUserId/{userID}")]
        public async Task<IActionResult> GetWalletByUserId(int userID)
        {
            try
            {
                var wallet = await _iUserService.GetWalletByUserId(userID);
                if (wallet == null)
                {
                    return Conflict(new { Message = "User not found" });
                }
                return Ok(wallet);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Message = "Internal server error", ExceptionMessage = ex.Message });
            }
        }

        [HttpPost("updateWalletValue")]
        public async Task<IActionResult> UpdateWalletValue([FromBody] userWalletUpdateRequest userWalletUpdateReq)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }

                var updatedWalletValue = await _iUserService.UpdateWalletValue(userWalletUpdateReq.UserId.Value, userWalletUpdateReq.Wallet.Value);
                if (updatedWalletValue != null)
                {
                    return Ok(new { Message = "Wallet value updated sucessfully!" });
                }
                else
                {
                    return NotFound(new { Message = "User not found" });
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Message = "Internal server error", ExceptionMessage = ex.Message });
            }
        }
    }
}
