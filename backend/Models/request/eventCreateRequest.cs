using System.ComponentModel.DataAnnotations;

namespace backend.Models.request
{
    public class eventCreateRequest
    {
        [Required]
        public DateTime? startTime { get; set; }

        [Required]
        public DateTime? endTime { get; set; }
        [Required]
        public TimeSpan? chargeTime { get; set; }

        [Required]
        public decimal? volume { get; set; }
        [Required]
        public decimal? price { get; set; }

        [Required]
        public int? userID { get; set; }

        [Required]
        public int? chargerID { get; set; }
    }
}