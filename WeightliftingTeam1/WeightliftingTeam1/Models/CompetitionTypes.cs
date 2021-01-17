using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace WeightliftingTeam1.Models
{
    public partial class CompetitionTypes
    {
        public CompetitionTypes()
        {
            Competitions = new HashSet<Competitions>();
        }
        [Editable(false)]
        public int Id { get; set; }
        public string Name { get; set; }

        public virtual ICollection<Competitions> Competitions { get; set; }
    }
}
