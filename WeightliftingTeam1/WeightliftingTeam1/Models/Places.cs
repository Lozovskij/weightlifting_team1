using System;
using System.Collections.Generic;

namespace WeightliftingTeam1.Models
{
    public partial class Places
    {
        public Places()
        {
            Competitions = new HashSet<Competitions>();
        }

        public int Id { get; set; }
        public string Name { get; set; }
        public int? CountryId { get; set; }

        public virtual Countries Country { get; set; }
        public virtual ICollection<Competitions> Competitions { get; set; }
    }
}
