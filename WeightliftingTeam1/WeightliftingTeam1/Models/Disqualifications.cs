using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace WeightliftingTeam1.Models
{
    public partial class Disqualifications
    {
        [Editable(false)]
        public int Id { get; set; }
        public string Reason { get; set; }
        public int? AttemptId { get; set; }

        public virtual Attempts Attempt { get; set; }
    }
}
