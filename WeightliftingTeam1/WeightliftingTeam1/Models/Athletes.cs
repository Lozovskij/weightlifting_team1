using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace WeightliftingTeam1.Models
{
    public partial class Athletes
    {
        public Athletes()
        {
            AthleteComments = new HashSet<AthleteComments>();
            Attempts = new HashSet<Attempts>();
        }
        [Editable(false)]
        public int Id { get; set; }
        public string Name { get; set; }
        public int? CountryId { get; set; }
        public string About { get; set; }
        public DateTime? BirthDate { get; set; }
        public string ImageUrl { get; set; }
        public string NameEn { get; set; }
        public string Sex { get; set; }

        public virtual Countries Country { get; set; }
        public virtual ICollection<AthleteComments> AthleteComments { get; set; }
        public virtual ICollection<Attempts> Attempts { get; set; }
    }
}
