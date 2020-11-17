using System;
using System.Collections.Generic;

namespace WeightliftingTeam1.Models
{
    public partial class Comments
    {
        public int Id { get; set; }
        public string Content { get; set; }
        public DateTime Date { get; set; }
        public int? Userid { get; set; }
        public int? Attemptid { get; set; }
        public bool? Ban { get; set; }
        public int? Updated { get; set; }

        public virtual Attempts Attempt { get; set; }
    }
}
