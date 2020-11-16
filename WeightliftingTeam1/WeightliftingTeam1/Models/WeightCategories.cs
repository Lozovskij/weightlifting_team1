using System;
using System.Collections.Generic;

namespace WeightliftingTeam1
{
    public partial class WeightCategories
    {
        public WeightCategories()
        {
            Records = new HashSet<Records>();
        }

        public int Id { get; set; }
        public int PeriodId { get; set; }
        public float? FromW { get; set; }
        public float? ToW { get; set; }
        public bool Active { get; set; }
        public string Type { get; set; }
        public string Name { get; set; }

        public virtual Periods Period { get; set; }
        public virtual ICollection<Records> Records { get; set; }
    }
}
