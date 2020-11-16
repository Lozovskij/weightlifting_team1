using System;
using System.Collections.Generic;

namespace WeightliftingTeam1
{
    public partial class Disqualifications
    {
        public int Id { get; set; }
        public string Reason { get; set; }
        public int? AttemptId { get; set; }

        public virtual Attempts Attempt { get; set; }
    }
}
