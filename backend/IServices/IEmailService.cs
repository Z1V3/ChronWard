namespace backend.IServices
{
    public interface IEmailService
    {
        Task SendPasswordResetEmail(string username, string email, string password);
    }
}
