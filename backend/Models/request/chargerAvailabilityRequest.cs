using System.ComponentModel.DataAnnotations;

namespace backend.Models.request
{
    public class chargerAvailabilityRequest
    {
        [Required]
        public int? ChargerID { get; set; }

        [Required]
        public bool? Occupied { get; set; }
    }
}
