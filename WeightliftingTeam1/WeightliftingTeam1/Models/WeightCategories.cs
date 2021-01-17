using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace WeightliftingTeam1.Models
{
    public partial class WeightCategories
    {
        public WeightCategories()
        {
            Records = new HashSet<Records>();
        }
        [Editable(false)]
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
