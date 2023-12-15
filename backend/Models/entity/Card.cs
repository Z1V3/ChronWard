using System;
using System.Collections.Generic;

namespace backend.Models.entity
{
    public partial class Card
    {
        public int CardId { get; set; }
        public int UserId { get; set; }
        public string Value { get; set; }
        public bool Active { get; set; }

        public virtual User User { get; set; } = null!;
    }
}
