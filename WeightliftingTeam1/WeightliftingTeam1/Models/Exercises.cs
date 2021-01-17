using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace WeightliftingTeam1.Models
{
    public partial class Exercises
    {
        public Exercises()
        {
            Attempts = new HashSet<Attempts>();
            Records = new HashSet<Records>();
        }
        [Editable(false)]
        public int Id { get; set; }
        public string Name { get; set; }

        public virtual ICollection<Attempts> Attempts { get; set; }
        public virtual ICollection<Records> Records { get; set; }
    }
}
