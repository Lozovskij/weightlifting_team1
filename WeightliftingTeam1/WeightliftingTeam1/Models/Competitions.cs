using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace WeightliftingTeam1.Models
{
    public partial class Competitions
    {
        public Competitions()
        {
            Attempts = new HashSet<Attempts>();
        }

        public string Name { get; set; }
        public int? PlaceId { get; set; }
        [Editable(false)]
        public int Id { get; set; }
        public int? Type { get; set; }
        public DateTime? DateEnd { get; set; }
        public DateTime? DateStart { get; set; }
        public string SourceInfo { get; set; }
        public bool? IsEnd { get; set; }

        public virtual Places Place { get; set; }
        public virtual CompetitionTypes TypeNavigation { get; set; }
        public virtual ICollection<Attempts> Attempts { get; set; }
    }
}
