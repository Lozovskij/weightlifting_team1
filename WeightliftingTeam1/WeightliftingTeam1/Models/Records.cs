using System;
using System.Collections.Generic;

namespace WeightliftingTeam1.Models
{
    public partial class Records
    {
        public int Id { get; set; }
        public int AttemptId { get; set; }
        public int CategoryId { get; set; }
        public int RecordType { get; set; }
        public int ExerciseId { get; set; }
        public bool? Active { get; set; }
        public DateTime Added { get; set; }

        public virtual Attempts Attempt { get; set; }
        public virtual WeightCategories Category { get; set; }
        public virtual Exercises Exercise { get; set; }
        public virtual RecordTypes RecordTypeNavigation { get; set; }
    }
}
