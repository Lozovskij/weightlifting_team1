using System;
using System.Collections.Generic;

namespace WeightliftingTeam1.Models
{
    public partial class Periods
    {
        public Periods()
        {
            WeightCategories = new HashSet<WeightCategories>();
        }

        public int Id { get; set; }
        public string Name { get; set; }

        public virtual ICollection<WeightCategories> WeightCategories { get; set; }
    }
}
