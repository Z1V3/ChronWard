using System.ComponentModel.DataAnnotations;

namespace backend.Models.request
{
    public class chargerCreateRequest
    {
        [Required]
        public string Name { get; set; } = null!;

        [Required]
        public decimal? Latitude { get; set; }

        [Required]
        public decimal? Longitude { get; set; }

        [Required]
        public int? Creator { get; set; }
    }
}
