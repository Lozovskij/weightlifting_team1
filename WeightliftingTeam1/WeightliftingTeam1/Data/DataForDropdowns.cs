using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WeightliftingTeam1.Data
{
    public struct DataForDropdowns
    {
        public DataForDropdowns(IEnumerable<string> competitions, IEnumerable<string> athleteNames, 
            IEnumerable<string> countries)
        {
            Competitions = competitions;
            Countries = countries;
            AthleteNames = athleteNames;
        }
        public IEnumerable<string> Competitions { get; set; }
        public IEnumerable<string> AthleteNames { get; set; }
        public IEnumerable<string> Countries { get; set; }
    }
}
