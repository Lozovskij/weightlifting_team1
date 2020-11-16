using System;
using System.Collections.Generic;

namespace WeightliftingTeam1
{
    public partial class RecordTypes
    {
        public RecordTypes()
        {
            Records = new HashSet<Records>();
        }

        public string Name { get; set; }
        public int Id { get; set; }

        public virtual ICollection<Records> Records { get; set; }
    }
}
