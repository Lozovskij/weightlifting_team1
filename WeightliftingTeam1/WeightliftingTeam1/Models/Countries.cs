using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace WeightliftingTeam1.Models
{
    public partial class Countries
    {
        public Countries()
        {
            Athletes = new HashSet<Athletes>();
            Attempts = new HashSet<Attempts>();
            Places = new HashSet<Places>();
        }
        [Editable(false)]
        public int Id { get; set; }
        public string Name { get; set; }
        public string ShortName { get; set; }
        public string ShortName2 { get; set; }
        public bool Exists { get; set; }
        public string RuName { get; set; }

        public virtual ICollection<Athletes> Athletes { get; set; }
        public virtual ICollection<Attempts> Attempts { get; set; }
        public virtual ICollection<Places> Places { get; set; }
    }
}
