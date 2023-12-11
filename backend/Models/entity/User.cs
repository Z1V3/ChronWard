using System;
using System.Collections.Generic;

namespace backend.Models.entity
{
    public partial class User
    {
        public User()
        {
            Cards = new HashSet<Card>();
            Chargers = new HashSet<Charger>();
            Events = new HashSet<Event>();
        }

        public int UserId { get; set; }
        public string Username { get; set; } = null!;
        public string Email { get; set; } = null!;
        public string Password { get; set; } = null!;
        public bool Active { get; set; }
        public DateTime Created { get; set; }
        public string Role { get; set; } = null!;

        public virtual ICollection<Card> Cards { get; set; }
        public virtual ICollection<Charger> Chargers { get; set; }
        public virtual ICollection<Event> Events { get; set; }
    }
}
