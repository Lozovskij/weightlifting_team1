using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WeightliftingTeam1.ModelsForOutput;

namespace WeightliftingTeam1.Panels
{
    public class AggregationPanels
    {
        public AttemptPanel AttemptPanel;
        public AggregationPanels(string[] competitions, string[] athleteNames)
        {
            AttemptPanel = new AttemptPanel(competitions, athleteNames);
        }


        public string WeightCategory { get; set; }

        public int Weight { get; set; }

        public bool IsMale { get; set; } = true;

        public bool IsFemale { get; set; } = true;

        public bool IsDisqualified { get; set; }
    }
}
