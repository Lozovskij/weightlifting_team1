using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WeightliftingTeam1.Panels
{
    public class AthletePanel
    {
        public bool WomenIsIncluded { get; set; } = true;
        public bool MenIsIncluded { get; set; } = true;
        public string Name { get; set; }
        public string Country { get; set; }
    }
}
