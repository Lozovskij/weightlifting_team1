using System;
using System.Collections.Generic;

namespace WeightliftingTeam1
{
    public partial class AttemptCategory
    {
        public int AttemptId { get; set; }
        public int CategoryId { get; set; }

        public virtual Attempts Attempt { get; set; }
        public virtual WeightCategories Category { get; set; }
    }
}
