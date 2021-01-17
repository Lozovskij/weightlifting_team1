using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace WeightliftingTeam1.Models
{
    public partial class RecordTypes
    {
        public RecordTypes()
        {
            Records = new HashSet<Records>();
        }

        public string Name { get; set; }
        [Editable(false)]
        public int Id { get; set; }

        public virtual ICollection<Records> Records { get; set; }
    }
}
