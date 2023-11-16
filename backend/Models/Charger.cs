using System;
using System.Collections.Generic;

namespace backend.Models
{
    public partial class Charger
    {
        public Charger()
        {
            Events = new HashSet<Event>();
        }

        public int ChargerId { get; set; }
        public double Latitude { get; set; }
        public double Longitude { get; set; }
        public DateTime Created { get; set; }
        public DateTime Lastsync { get; set; }
        public int Creator { get; set; }

        public virtual User CreatorNavigation { get; set; } = null!;
        public virtual ICollection<Event> Events { get; set; }
    }
}
