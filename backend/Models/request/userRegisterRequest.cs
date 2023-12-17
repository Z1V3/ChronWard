namespace backend.Models.request
{
    public class userRegisterRequest
    {
        public string username { get; set; } = null!;
        public string email { get; set; } = null!;
        public string password { get; set; } = null!;
    }
}
