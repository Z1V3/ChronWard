using System.ComponentModel.DataAnnotations;

namespace backend.Models.request
{
    public class userWalletUpdateRequest
    {
        [Required]
        public int? UserId { get; set; }

        [Required]
        public decimal? Wallet { get; set; }
    }
}
