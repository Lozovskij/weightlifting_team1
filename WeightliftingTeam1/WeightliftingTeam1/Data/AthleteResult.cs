using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WeightliftingTeam1.Data
{
    public class AthleteResult
    {
        public int Id { get; set; }

        public string FullName { get; set; }

        public double Weight { get; set; }

        public int TotalResult { get; set; }

        public string Nation { get; set; }
    }
}
