using System;
using System.Collections.Generic;

namespace backend.Models.entity
{
    public partial class Charger
    {
        public Charger()
        {
            Events = new HashSet<Event>();
        }

        public int ChargerId { get; set; }
        public string Name { get; set; } = null!;
        public decimal Latitude { get; set; }
        public decimal Longitude { get; set; }
        public DateTime Created { get; set; }
        public int Creator { get; set; }
        public DateTime Lastsync { get; set; }
        public bool Active { get; set; }
        public bool Occupied { get; set; }

        public virtual User CreatorNavigation { get; set; } = null!;
        public virtual ICollection<Event> Events { get; set; }
    }
}
