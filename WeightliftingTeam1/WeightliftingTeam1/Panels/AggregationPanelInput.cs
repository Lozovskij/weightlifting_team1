using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WeightliftingTeam1.ModelsForOutput;

namespace WeightliftingTeam1.Panels
{
    public class AggregationPanelInput
    {
        public Athlete AthleteItem;
        public Attempt AttemptItem;

        public AttemptPanel AttemptPanel;

        public AggregationPanelInput()
        {
            AthleteItem = new Athlete();
            AttemptItem = new Attempt();

            AttemptPanel = new AttemptPanel();
        }

        public AggregationPanelInput(Athlete athleteItem, Attempt attemptItem)
        {
            AthleteItem = athleteItem;
            AttemptItem = attemptItem;
        }

        public string WeightCategory { get; set; }

        public int Weight { get; set; }

        public bool IsMale { get; set; } = true;

        public bool IsFemale { get; set; } = true;

        public bool IsDisqualified { get; set; }
    }
}
