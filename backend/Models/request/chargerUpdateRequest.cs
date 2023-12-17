using System.ComponentModel.DataAnnotations;

namespace backend.Models.request
{
    public class chargerUpdateRequest
    {
        [Required]
        public int? ChargerID { get; set; }
        [Required]
        public string Name { get; set; } = null!;

        [Required]
        public decimal? Latitude { get; set; }

        [Required]
        public decimal? Longitude { get; set; }

        [Required]
        public bool? Active { get; set; }
    }
}
