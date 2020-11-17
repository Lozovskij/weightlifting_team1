using System;
using System.Collections.Generic;

namespace WeightliftingTeam1.Models
{
    public partial class CompetitionTypes
    {
        public CompetitionTypes()
        {
            Competitions = new HashSet<Competitions>();
        }

        public int Id { get; set; }
        public string Name { get; set; }

        public virtual ICollection<Competitions> Competitions { get; set; }
    }
}
