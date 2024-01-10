using backend.IServices;
using System.Net;
using System.Net.Mail;
using System.Threading.Tasks;

public class EmailService : IEmailService
{
    public async Task SendPasswordResetEmail(string username, string toEmail, string password)
    {
        string senderEmail = "EvChargeAir@gmail.com";
        string senderPassword = "oyfwqpbmxbeimlon";
        string smtpServer = "smtp.gmail.com";
        int smtpPort = 587;

        using (var message = new MailMessage())
        {
            message.From = new MailAddress(senderEmail);
            message.To.Add(new MailAddress(toEmail));
            message.Subject = "Reset password email";

            message.Body = $@"<html>
                                <head>
                                    <!-- Add your CSS styles here if needed -->
                                </head>
                                <body>
                                    <p>Hello {username},</p>
                                    <p>We have generated a new password for your account.</p>
                                    <p>This is your new password: <strong>{password}</strong>.</p>
                                    <p>Yours sincerely,</p>
                                    <p>EVCharge</p>
                                </body>
                            </html>";
            message.IsBodyHtml = true;

            using (var client = new SmtpClient(smtpServer, smtpPort))
            {
                client.Credentials = new NetworkCredential(senderEmail, senderPassword);
                client.EnableSsl = true;

                await client.SendMailAsync(message);
            }
        }
    }
}

