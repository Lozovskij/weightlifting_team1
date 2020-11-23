using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WeightliftingTeam1.ModelsForOutput;

namespace WeightliftingTeam1.Data
{
    public class DataForGrids
    {
        public IEnumerable<Attempt> DefaultAttempts { get; set; }
        public IEnumerable<Athlete> DefaultAthletes { get; set; }
        public IEnumerable<Attempt> Attempts { get; set; }
        public IEnumerable<Athlete> Athletes { get; set; }
    }
}
