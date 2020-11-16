using System;
using System.Collections.Generic;

namespace WeightliftingTeam1
{
    public partial class AthleteComments
    {
        public int Id { get; set; }
        public string Content { get; set; }
        public DateTime Date { get; set; }
        public int? Userid { get; set; }
        public int? Athleteid { get; set; }
        public bool? Ban { get; set; }
        public int? Updated { get; set; }

        public virtual Athletes Athlete { get; set; }
    }
}
