using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WeightliftingTeam1.Data
{
    public struct DataForDropdowns
    {
        public DataForDropdowns(IEnumerable<string> competitions, IEnumerable<string> athleteNames)
        {
            Competitions = competitions;
            AthleteNames = athleteNames;
        }
        public IEnumerable<string> Competitions { get; private set; }
        public IEnumerable<string> AthleteNames { get; private set; }
    }
}
