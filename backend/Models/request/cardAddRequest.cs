using System.ComponentModel.DataAnnotations;

namespace backend.Models.request
{
    public class cardAddRequest
    {
        [Required]
        public int? UserID { get; set; }

        [Required]
        public string Value { get; set; } = null!;
    }
}
