using System;
using System.Collections.Generic;

namespace WeightliftingTeam1
{
    public partial class Attempts
    {
        public Attempts()
        {
            Comments = new HashSet<Comments>();
            Disqualifications = new HashSet<Disqualifications>();
            Records = new HashSet<Records>();
        }

        public float Result { get; set; }
        public int AthleteId { get; set; }
        public int Id { get; set; }
        public DateTime? Date { get; set; }
        public int? CompetitionId { get; set; }
        public int ExerciseId { get; set; }
        public float? AthleteWeight { get; set; }
        public string SourceInfo { get; set; }
        public bool? IsWinResult { get; set; }
        public int? AthleteCountryId { get; set; }
        public bool IsDsq { get; set; }
        public DateTime? Added { get; set; }
        public int? AddedBy { get; set; }
        public bool HasVideo { get; set; }
        public bool Failed { get; set; }
        public DateTime? Updated { get; set; }
        public int? UpdatedBy { get; set; }

        public virtual Athletes Athlete { get; set; }
        public virtual Countries AthleteCountry { get; set; }
        public virtual Competitions Competition { get; set; }
        public virtual Exercises Exercise { get; set; }
        public virtual ICollection<Comments> Comments { get; set; }
        public virtual ICollection<Disqualifications> Disqualifications { get; set; }
        public virtual ICollection<Records> Records { get; set; }
    }
}
